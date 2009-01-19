
module Rl2
  class Base
    def self.config options={}
      @@cache_dir = options[:cache_dir]
    end
    
    def self.cache_dir
      @@cache_dir ||= '/tmp'
      @@cache_dir
    end
  end
end
