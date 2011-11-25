require 'yaml'
require 'ostruct'
require 'git'

require 'gync/git'

module Gync
  extend self
  class Error < Exception; end

  def print_help
    puts "HELP MESSAGE"
  end
  
  def run(command)
    @opts = opts_for command
    git = Gync::Git.new(@opts.local)
    git.pull
    system command
    git.push
  rescue Exception => err
    STDERR.puts err
    raise err
    exit 1
  end

  def home_dir
    ENV['HOME']
  end

  def config_file
    ENV['GYNC_CONFIG'] || File.join(home_dir, '.gync.yml')
  end

  def opts_for(command)
    opts = YAML.load_file(config_file)
    # validate
    result = opts[command] || raise("There is no `#{command}` section #{config_file}")
    result['local'] || raise("There is no `#{command}.local` section #{config_file}")
    result['remote'] || raise("There is no `#{command}.remote` section #{config_file}")
    OpenStruct.new(result)
  end
end
