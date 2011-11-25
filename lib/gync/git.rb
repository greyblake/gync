module Gync
  class Git
    attr_reader :repo_path
    def initialize(repo_path)
      @repo_path = repo_path
      @git = ::Git.open(repo_path)
    end

    def pull
      @git = ::Git.open(repo_path)
      @git.fetch
      @git.merge 'origin/master'
    end

    def push
      @git = ::Git.open(repo_path)
      @git.add changed_files
      @git.commit "Gync commit"
      @git.push "origin", "master"
    end

    def changed_files
      if RUBY_VERSION =~ /^1.8/
        @git.status.changed.map{|f| f.first}
      else
        @git.status.changed.keys
      end
    end
  end
end
