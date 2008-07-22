require 'uri'

module Rl2
  # 2ch の板を表すクラス。
  class Rl2chBbs
    END_WITH_SLASH = /\/$/
    
    # 板のトップページのURL。
    attr_accessor :url
    # 板のホスト。例えば、
    # - anime3.2ch.net
    # - jbbs.livedoor.jp/computer
    attr_accessor :host
    # 板のキー。例えば、
    # - 4koma
    # - 1293
    attr_accessor :bbs
    
    # 板のトップページのURLからインスタンスを生成する。
    def initialize index_url
      @url = index_url
      @host, @bbs = get_host_and_bbs(index_url)
    end
    
    def get_host_and_bbs url
      uri = URI.parse(url)
      path = uri.path.split('/')
      path.shift
      path.pop unless END_WITH_SLASH =~ url
      bbs = path.pop
      host = uri.host
      host = "#{host}/#{path.join('/')}" if path.length > 0
      return [ host, bbs ]
    end
    
    def subject_txt_url
      "http://#{host}/#{bbs}/subject.txt"
    end
  end
end