$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rl2/version'

module Rl2
  USER_AGENT = "Monazilla/1.00 (rl2/#{Rl2::VERSION::STRING})"
end