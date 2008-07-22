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
  end
end