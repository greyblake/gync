$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

GYNC_ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')
ENV['PATH'] = "#{GYNC_ROOT}/bin:" + ENV['PATH']
ENV['PATH'] = "#{GYNC_ROOT}/spec/bin:" + ENV['PATH']

require 'rspec'
require 'gync'
require 'ruby-debug'
require 'fileutils'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

