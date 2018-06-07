require_relative './spec_helper'

describe 'git-secret::test' do

  describe package('git-secret') do
    it { should be_installed }
  end

  if host_inventory['platform'] == 'fedora' || host_inventory['platform'] == 'redhat'
    describe command('find /tmp/git-secret/build -name "*.rpm"') do
      its(:stdout) { should match /git-secret.*rpm/ }
    end
  elsif host_inventory['platform'] == 'alpine'
    describe command('find /tmp/git-secret/build -name "*.apk"') do
      its(:stdout) { should match /git-secret.*apk/ }
    end
  else
    describe command('find /tmp/git-secret/build -name "*.deb"') do
      its(:stdout) { should match(/git-secret.*deb/) }
    end
  end

  describe file('/.git-secret_test-passed') do
    it { should exist }
  end

  if host_inventory['platform'] == 'fedora' || host_inventory['platform'] == 'redhat'
    describe command('rpm --query --info git-secret') do
      its(:exit_status) { should eq 0 }
    end
  elsif host_inventory['platform'] == 'alpine'
    describe command('apk info git-secret') do
      its(:exit_status) { should eq 0 }
    end
  else
    describe command('dpkg-query --status git-secret') do
      its(:exit_status) { should eq 0 }
    end
  end

  describe command('man -w "git-secret"') do
    its(:exit_status) { should eq 0 }
  end

  describe command('man -w "git-secret-init"') do
    its(:exit_status) { should eq 0 }
  end

end
