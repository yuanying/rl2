require File.dirname(__FILE__) + '/spec_helper.rb'
require 'rl2/thread/base'

describe "http://anime3.2ch.net/4koma/ 板の、キーが 1174691082 のスレッド" do
  before do
    @thread = Rl2::Thread::Base.new( 'http://anime3.2ch.net/4koma/', 1174691082 )
  end
  
  it "のスレッドのデータをキャッシュするファイルのパスは、 'Rl2::Base.cache_dir + /anime3.2ch.net/4koma/1174691082.dat' である。" do
    @thread.cached_dat_path.should == "#{Rl2::Base.cache_dir}/anime3.2ch.net/4koma/1174691082.dat"
  end
  
  it "の dat の url は、'http://anime3.2ch.net/4koma/dat/1174691082.dat' である。" do
    @thread.dat_url.should == 'http://anime3.2ch.net/4koma/dat/1174691082.dat'
  end
end