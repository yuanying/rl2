require 'rl2/thread'
require 'kconv'

module Rl2::Thread
  class Res
    attr_accessor :name, :email, :date, :id, :be_id, :body, :title
  end
  
  class Parser
    attr_reader :logger

    def initialize options={}
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    # Uconv.sjistou8
    def parse io
      rtn = []
      io.each do |line|
        res = Res.new
        line = line.kconv(Kconv::UTF8,  Kconv::SJIS)
        # line = line.toutf8
        res.name, res.email, res.date, res.body, res.title = line.split( '<>' )
        rtn << res
      end
      return rtn
    end
  end
end
