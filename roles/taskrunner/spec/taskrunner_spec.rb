require 'spec_helper'


describe "checking Task Runner of Data Pipeline" do

  property['packages'].each do |pkg|
    context package(pkg), :if => os[:family] == 'redhat' do
      it { should be_installed }
    end
  end

  %w{ base_dir bin_dir conf_dir }.each do |dir|
    context file("#{property['datapipeline'][dir]}") do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end
  end

  context file("#{property['datapipeline']['bin_dir']}/TaskRunner.jar") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  context file("#{property['datapipeline']['conf_dir']}/config.json") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /#{property['taskrunner']['access_key']}/ }
    its(:content) { should match /#{property['taskrunner']['private_key']}/ }
    its(:content) { should match /#{property['taskrunner']['region']}/ }
    its(:content) { should match /#{property['taskrunner']['log_uri']}/ }
    its(:content) { should match /#{property['taskrunner']['workergroup']}/ }
  end

  context file('/etc/systemd/system/taskrunner.service') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  context service('taskrunner') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

end
