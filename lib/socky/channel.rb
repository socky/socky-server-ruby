module Socky
  class Channel
    ROOT = File.expand_path(File.dirname(__FILE__))

    autoload :Base,     "#{ROOT}/channel/base"
    autoload :Private,  "#{ROOT}/channel/private"
    autoload :Public,   "#{ROOT}/channel/public"
  end
end