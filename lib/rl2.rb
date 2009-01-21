$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rl2
  USER_AGENT = 'Monazilla/1.00 (rl2/1.00)'
end