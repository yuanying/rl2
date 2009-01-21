require 'rl2/bbs/base'
require 'uri'
require 'net/http'
require 'zlib'
require 'stringio'
require 'logger'
require 'kconv'

module Rl2::BBS
  class BBSMovedResolver
    attr_reader :logger
  
    def initialize options={}
      @logger = options[:logger] || Logger.new(STDOUT)
    end
    
    def resolve bbs
      if bbs.kind_of?(String)
        bbs = ::Rl2::BBS::Base.new(bbs)
      end
      
      index_html = download_index bbs
      moved_url = parse_index_html( index_html )
      if moved_url
        bbs = ::Rl2::BBS::Base.new(moved_url)
      end
      return bbs
    end
    
    def download_index bbs
      data = ''
      Net::HTTP.version_1_2
      uri = URI.parse( bbs.index_url )
      
      Net::HTTP.start( uri.host, uri.port ) do |http|
        response = http.get( uri.path, { 'Accept-Encoding' => 'gzip' } )
        
        if response['Content-Encoding'] == 'gzip'
          StringIO.open( response.body ) do |io|
            Zlib::GzipReader.wrap(io) do |gz|
              data = gz.read
            end
          end
        else
          data = response.body
        end
      end
      
      return data.kconv(Kconv::UTF8, Kconv::SJIS)
    end
    
    def parse_index_html index_html
      if /<title>2chbbs..<\/title>/ =~ index_html
        if /<a href="(.+)">GO !<\/a>/ =~ index_html
          return $1
        end
      end
      return nil
    end
  end
end
