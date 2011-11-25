require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "Gync" do
  def config_path
    "/tmp/test_gync_config.yml"
  end

  def local_repo
    "/tmp/gync_test_local_repo"
  end

  def remote_repo
    "/tmp/gync_test_remote_repo"
  end

  def config_content
    <<-CONFIG
gync_test_app:
  local: "#{local_repo}"
  remote: "#{remote_repo}"
    CONFIG
  end

  def create_remote_repo
    FileUtils.mkdir_p remote_repo    
    FileUtils.cd remote_repo
    FileUtils.touch "file_1"
    FileUtils.touch "file_2"
    git = Git.init
    git.add ["file_1", "file_2"]
    git.commit "initial commit"
  end

  def create_local_repo
    Git.clone remote_repo, local_repo
  end

  before(:all) do
    ENV['GYNC_CONFIG'] = config_path
    File.open(config_path, 'w'){|f| f.puts config_content}
    create_remote_repo
    create_local_repo
  end

  after(:all) do
    FileUtils.rm_rf remote_repo
    FileUtils.rm_rf local_repo
  end

  it "do" do
    puts  %x"which gync"
  end

end
