require 'mongoid'
#require 'robots'
#require 'nokogiri'

lib_rb_files = File.join("./lib/**", "*.rb")

Dir.glob(lib_rb_files).each do |filename|
  require filename
end
