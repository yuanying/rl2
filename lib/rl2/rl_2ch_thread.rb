require 'rl2/base'

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
      @key = key
    end
    
    def dat_url
      "#{self.bbs.base_url}/dat/#{self.key}.dat"
    end
    
    def cached_dat_path
      File.join( Rl2::Base.cache_dir, self.bbs.host, self.bbs.bbs, self.key + '.dat' )
    end
  end
end