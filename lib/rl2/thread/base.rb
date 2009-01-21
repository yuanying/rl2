require 'rl2/thread'
require 'rl2/base'
require 'rl2/bbs/base'
require 'uri'
require 'net/http'
require 'logger'

module Rl2::Thread
  # 2ch のスレッドを表すクラス。
  class Base
    # RL2::BBS::Base のインスタンス
    attr_accessor :bbs
    # スレッドのキー
    attr_accessor :key
    
    attr_reader :logger
    
    # 板とスレッドのキーからインスタンスを生成する。
    def initialize bbs, key, options={}
      @logger = options[:logger] || Logger.new(STDOUT)
      
      if bbs.kind_of?(String)
        @bbs = ::Rl2::BBS::Base.new(bbs)
      else
        @bbs = bbs
      end
      @key = key.to_s
    end
    
    def download
      d = Downloader.new( :logger => self.logger )
      d.dat_download dat_url, cached_dat_path
    end
    
    # thread の内容をリストで返す。
    def data
      p = Parser.new( :logger => self.logger )
      open( cached_dat_path ) do |io|
        p.parse( io )
      end
    end
    
    def dat_url
      "#{self.bbs.base_url}/dat/#{self.key}.dat"
    end
    
    def cached_dat_path
      thread_unique_path + '.dat'
    end
    
    def thread_unique_path
      File.join( Rl2::Base.cache_dir, self.bbs.host, self.bbs.bbs, self.key )
    end
  end
end