require 'yaml'
require 'ostruct'
require 'socket'
require 'shellwords'
require 'git'
require 'gync/git'

module Gync
  extend self
  def print_help
    puts <<-HELP
Synchronizes application data using git.
Usage:
    gync COMMAND <command_options>
    gync --help

For more help please visit https://github.com/greyblake/gync
    HELP
  end
  
  def run(args)
    @opts = opts_for args.first
    git = Gync::Git.new(@opts.local, @opts.remote)
    git.pull
    system Shellwords.shelljoin args
    git.push
  rescue Exception => err
    STDERR.puts err
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
    result['local']        || raise("There is no `#{command}.local` section #{config_file}")
    result['remote']       || raise("There is no `#{command}.remote` section #{config_file}")
    OpenStruct.new(result)
  end
end
