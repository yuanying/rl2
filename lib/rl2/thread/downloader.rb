require 'rl2/thread'
require 'uri'
require 'net/http'
require 'zlib'
require 'stringio'
require 'logger'
require 'time'

class Rl2::Thread::Downloader
  attr_reader :logger
  
  def initialize options={}
    @logger = options[:logger] || Logger.new(STDOUT)
  end
  
  def dat_download dat_url, path
    Net::HTTP.version_1_2
    uri = URI.parse( dat_url )
    
    Net::HTTP.start( uri.host, uri.port ) do |http|
      if File.exists?( path )
        dat_download_second_or_later http, uri.path, path
      else
        dat_download_first_time http, uri.path, path
      end
    end
  end
  
  def dat_download_first_time http, dat_path, path
    logger.debug( 'download dat at first time.' )
    response = http.get( dat_path, { 'Accept-Encoding' => 'gzip', 'User-Agent' => Rl2::USER_AGENT } )
    raise 'DAT can not download.' if response.code.to_i >= 300
    
    modified_time = Time.httpdate(response['Last-Modified']) if response['Last-Modified']
    
    open( path, 'w' ) do |cache|
      if response['Content-Encoding'] == 'gzip'
        StringIO.open( response.body ) do |io|
          Zlib::GzipReader.wrap(io) do |gz|
            cache.write( gz.read.chop )
          end
        end
      else
        cache.write( response.body.chop )
      end
    end
    File.utime( modified_time, modified_time, path ) if modified_time
  end
  
  def dat_download_second_or_later http, dat_path, path
    logger.debug( 'download dat at second or later time.' )
    stat = File.stat( path )
    last_modified_time = File.mtime( path )
    
    response = http.get( dat_path, {
      'If-Modified-Since' => last_modified_time.httpdate,
      'Range' => "bytes= #{stat.size}-",
      'User-Agent' => Rl2::USER_AGENT
    } )
    modified_time = Time.httpdate(response['Last-Modified']) if response['Last-Modified']
    
    logger.debug( "response.code: #{response.code}" )
    return unless response.code.to_i == 206
    logger.debug( "check abon: #{response.body[0]}" )
    if ( response.body[0] == 10 )
      open( path, 'a' ) do |cache|
        logger.debug( "append body:\n#{response.body}" )
        cache.write( response.body.chop )
      end
    else
      logger.debug( "abon is detected." )
      dat_download_first_time http, dat_path, path
    end
    File.utime( modified_time, modified_time, path ) if modified_time
  end
end