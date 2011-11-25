require 'yaml'
require 'ostruct'
require 'git'

module Gync
  extend self
  class Error < Exception; end

  def print_help
    puts "HELP MESSAGE"
  end
  
  def run(command)
    @opts = opts_for command
    git_pull
    system command
    git_push
  rescue Exception => err
    STDERR.puts err
    raise err
    exit 1
  end

  def home_dir
    ENV['HOME']
  end

  def config_file
    File.join(home_dir, '.gync.yml')
  end

  def git_pull
    git = Git.open(@opts.local)
    git.fetch
    git.merge 'origin/master'
  end

  def git_push
    git = Git.open(@opts.local)
    changed_files = git.status.changed.keys
    git.add changed_files
    git.commit "Gync commit"
    git.push "origin", "master"
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
