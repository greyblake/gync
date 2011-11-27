module Gync
  class Git
    def initialize(local_path, remote_path)
      @local_path, @remote_path = local_path, remote_path
    end

    def pull
      reopen_repo!
      @git.fetch
      @git.merge 'origin/master'
    end

    def push
      reopen_repo!
      if not changed_files.empty? or not new_files.empty? or not removed_files.empty?
        @git.add    changed_files unless changed_files.empty?
        @git.add    new_files     unless new_files.empty?
        @git.remove removed_files unless removed_files.empty?
        @git.commit commit_msg
        @git.push "origin", "master"
      end
    end


    private 

    def reopen_repo!
      @git = ::Git.open(@local_path)
    rescue ArgumentError
      @git = ::Git.init(@local_path)
      @git.add_remote "origin", @remote_path
    end

    def changed_files
      get_file_names @git.status.changed
    end

    def new_files
      get_file_names @git.status.untracked
    end

    def removed_files
      get_file_names @git.status.deleted
    end

    def commit_msg
      host = Socket.gethostname
      if host and not host.empty?
        "Gync commit from #{host}"
      else
        "Gync commit"
      end
    end

    def get_file_names(files)
      if RUBY_VERSION =~ /^1.8/
        files.map{|f| f.first}
      else
        files.keys
      end
    end
  end
end
