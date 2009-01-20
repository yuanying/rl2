require 'rl2/base'
require 'rl2/rl_2ch_bbs'
require 'uri'
require 'net/http'

module Rl2
  # 2ch のスレッドを表すクラス。
  class Rl2chThread
    # RL2::Rl2chBbs のインスタンス
    attr_accessor :bbs
    # スレッドのキー
    attr_accessor :key
    
    # 板とスレッドのキーからインスタンスを生成する。
    def initialize bbs, key
      if bbs.kind_of?(String)
        @bbs = Rl2chBbs.new(bbs)
      else
        @bbs = bbs
      end
      @key = key.to_s
    end
    
    def download_dat path
      
    end
    
    def download_dat_first_time path
      Net::HTTP.version_1_2
      open( path, 'w' ) do |cache|
        uri = dat_uri
        Net::HTTP.start( uri.host, uri.port ) do |http|
          response = http.get( uri.path, { 'Accept-Encoding' => 'gzip' } )
        end
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