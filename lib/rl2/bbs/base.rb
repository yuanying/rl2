require 'uri'
require 'rl2/bbs'

class Rl2::BBS::Base
  END_WITH_EXTENTION = /\.\w+$/
  
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
    path.pop if END_WITH_EXTENTION =~ path.last
    bbs = path.pop
    host = uri.host
    host = "#{host}/#{path.join('/')}" if path.length > 0
    return [ host, bbs ]
  end
  
  def subject_txt_url
    "#{base_url}/subject.txt"
  end
  
  def index_url
    "#{base_url}/"
  end
  
  def base_url
    "http://#{host}/#{bbs}"
  end
end