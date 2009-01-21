require 'rl2/bbs'
require 'logger'

module Rl2::BBS
  class BBSMovedResolver
    attr_reader :logger
  
    def initialize options={}
      @logger = options[:logger] || Logger.new(STDOUT)
    end
    
    def resolve bbs
      if bbs.kind_of?(String)
        @bbs = ::Rl2::BBS::Base.new(bbs)
      else
        @bbs = bbs
      end
      
      
    end
  end
end
