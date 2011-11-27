require 'spec_helper'

describe "Gync" do
  def config_path       ; "/tmp/test_gync_config.yml"        ; end
  def init_repo         ; "/tmp/gync_test_init_repo"         ; end
  def local_repo        ; "/tmp/gync_test_local_repo"        ; end
  def pseudo_remote_repo; "/tmp/gync_test_pseudo_remote_repo"; end
  def remote_repo       ; "/tmp/gync_test_remote_repo"       ; end

  def config_content
    <<-CONFIG
      gync_test_app:
        local: "#{local_repo}"
        remote: "#{remote_repo}"
    CONFIG
  end

  def create_init_repo
    FileUtils.mkdir_p init_repo    
    FileUtils.cd init_repo
    FileUtils.touch "file_1"
    FileUtils.touch "file_2"
    git = Git.init
    git.add ["file_1", "file_2"]
    git.commit "initial commit"
  end

  def in_remote_repo
    git = Git.open pseudo_remote_repo
    git.fetch
    git.merge 'origin/master'
    FileUtils.cd pseudo_remote_repo
    yield git
    git.push "origin", "master"
  end

  def in_local_repo
    FileUtils.cd local_repo
    yield
  end

  def run_application!
    system "gync gync_test_app"
  end

  before(:each) do
    ENV['GYNC_CONFIG'] = config_path
    File.open(config_path, 'w'){|f| f.puts config_content}
    create_init_repo
    Git.clone init_repo, remote_repo, :bare => true
    Git.clone remote_repo, local_repo
    Git.clone remote_repo, pseudo_remote_repo
  end

  after(:each) do
    FileUtils.rm_rf remote_repo
    FileUtils.rm_rf init_repo
    FileUtils.rm_rf local_repo
    FileUtils.rm_rf pseudo_remote_repo
    FileUtils.rm_rf config_path
  end

  describe "when application starts" do
    it "pulls changes" do
      in_remote_repo do |git|
        FileUtils.touch "third_file"
        git.add "third_file"
        git.commit "second commit"
      end
      run_application!
      in_local_repo do
        File.exists?("./third_file").should == true
      end
    end
  end

  describe "when application is finished" do
    it "pushed changed files" do
      in_local_repo do
        File.open('./file_1', 'a+') {|f| f.puts "New content"}
      end
      run_application!
      in_remote_repo do |git|
        File.read('./file_1').should =~ /New content/
      end
    end

    it "pushes new files" do
      in_local_repo do
        File.open('./new_file', 'w') {|f| f.puts "New file content"}
      end
      run_application!
      in_remote_repo do |git|
        File.exists?('./new_file').should == true
        File.read('./new_file').should =~ /New file content/
      end
    end

    it "pushes removed files" do
      in_local_repo{ FileUtils.rm "./file_1" }
      run_application!
      in_remote_repo do |git|
        File.exists?('./file_1').should == false
      end
    end
  end

  describe "when there is no local repo yet" do
    before :each do
      FileUtils.rm_rf local_repo
      FileUtils.mkdir_p local_repo
      lambda{ Git.open local_repo}.should raise_error 
    end

    it "inits repo" do
      run_application!
      lambda{ Git.open local_repo}.should_not raise_error 
    end

    it "adds remote repo" do
      run_application!
      git = Git.open local_repo
      remote = git.remotes.first
      remote.should_not be_nil
      remote.name.should == "origin"
      remote.url.should == remote_repo
    end
  end
end
