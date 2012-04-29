require 'mongoid'
require './config/mongoid'
require 'colored'

lib_rb_files = File.join("./lib/**", "*.rb")

Dir.glob(lib_rb_files).each do |filename|
  require filename
end
