require File.dirname(__FILE__) + '/spec_helper.rb'
require 'rl2/bbs/base'

# Time to add your specs!
# http://rspec.info/
describe Rl2::BBS::Base do
  before do
  end
  
  it "should have host(anime3.2ch.net) and bbs key(4koma) which is created by 'http://anime3.2ch.net/4koma/'." do
    @bbs = Rl2::BBS::Base.new('http://anime3.2ch.net/4koma/')
    @bbs.host.should == 'anime3.2ch.net'
    @bbs.bbs.should == '4koma'
  end
  
  it "should have host(anime3.2ch.net) and bbs key(4koma) which is created by 'http://anime3.2ch.net/4koma'." do
    @bbs = Rl2::BBS::Base.new('http://anime3.2ch.net/4koma')
    @bbs.host.should == 'anime3.2ch.net'
    @bbs.bbs.should == '4koma'
  end
  
  it "should have host(www.machi.to) and bbs key(tawara) which is created by 'http://www.machi.to/tawara/index2.html'." do
    @bbs = Rl2::BBS::Base.new('http://www.machi.to/tawara/index2.html')
    @bbs.host.should == 'www.machi.to'
    @bbs.bbs.should == 'tawara'
  end
  
  it "should have host(jbbs.livedoor.jp/computer) and bbs key(1293) which is created by 'http://jbbs.livedoor.jp/computer/1293/index2.html'." do
    @bbs = Rl2::BBS::Base.new('http://jbbs.livedoor.jp/computer/1293/index2.html')
    @bbs.host.should == 'jbbs.livedoor.jp/computer'
    @bbs.bbs.should == '1293'
  end
  
end