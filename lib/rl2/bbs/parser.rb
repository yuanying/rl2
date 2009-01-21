require 'rl2/bbs'
require 'logger'
require 'kconv'

module Rl2::BBS
  class ThreadSummary
    attr_accessor :key, :title, :res_num
  end
  
  class Parser
    SUMMARY_LINE = /(\d+)\.dat<>(.*)\((\d+)\)$/
    attr_reader :logger

    def initialize options={}
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    # Uconv.sjistou8
    def parse io
      rtn = []
      io.each do |line|
        res = ThreadSummary.new
        line = line.kconv(Kconv::UTF8,  Kconv::SJIS)
        if SUMMARY_LINE =~ line
          res.key = $1
          res.title = $2
          res.res_num = $3.to_i
          rtn << res
        end
      end
      return rtn
    end
  end
end