require 'rl2/bbs'
require 'uri'
require 'net/http'
require 'zlib'
require 'stringio'
require 'logger'
require 'time'

# BBS の Subject をダウンロードするクラス.
module Rl2::BBS
  class SubjectNotFoundException < StandardError; end
  class SubjectMaybeMovedException < StandardError; end
  
  class Downloader
    attr_reader :logger
  
    def initialize options={}
      @logger = options[:logger] || Logger.new(STDOUT)
    end
  
    def subject_download subject_url, path
      Net::HTTP.version_1_2
      uri = URI.parse( subject_url )
    
      Net::HTTP.start( uri.host, uri.port ) do |http|
        if File.exists?( path )
          subject_download_second_or_later http, uri.path, path
        end
        subject_download_first_time http, uri.path, path
      end
    end
  
    def subject_download_first_time http, subject_path, path
      logger.debug( 'download subject at first time.' )
      response = http.get( subject_path, { 'Accept-Encoding' => 'gzip', 'User-Agent' => Rl2::USER_AGENT } )
      raise SubjectNotFoundException.new if response.code.to_i == 404
    
      save_response response, path
    end
    
    def subject_download_second_or_later http, subject_path, path
      logger.debug( 'download subject at second time.' )
      stat = File.stat( path )
      last_modified_time = File.mtime( path )
      
      response = http.get( subject_path, { 
        'If-Modified-Since' => last_modified_time.httpdate,
        'Accept-Encoding' => 'gzip', 
        'User-Agent' => Rl2::USER_AGENT 
      } )
      raise SubjectNotFoundException.new if response.code.to_i == 404
      
      if response.code.to_i < 300
        save_response response, path
      end
    end
    
    def save_response response, path
      modified_time = Time.httpdate(response['Last-Modified']) if response['Last-Modified']
      
      data = ''
      if response['Content-Encoding'] == 'gzip'
        StringIO.open( response.body ) do |io|
          Zlib::GzipReader.wrap(io) do |gz|
            data = gz.read
          end
        end
      else
        data = response.body
      end
      raise SubjectMaybeMovedException.new if data.size == 0
      
      open( path, 'w' ) do |cache|
        cache.write( data )
      end
      File.utime( modified_time, modified_time, path ) if modified_time
    end
  end
end