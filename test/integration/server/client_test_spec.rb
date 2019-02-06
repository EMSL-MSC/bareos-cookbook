# Validate the client resources and test recipes
fd_path = '/etc/bareos/bareos-fd.d'

describe package('bareos-filedaemon') do
  it { should be_installed }
end

describe directory(fd_path) do
  it { should exist }
end

%w(
  /client
  /director
  /messages
).each do |dir|
  describe directory(fd_path + dir) do
    it { should exist }
  end
end

%w(
  /client/myself.conf
  /director/bareos-dir.conf
  /director/bareos-mon.conf
  /messages/Standard.conf
).each do |config|
  describe file(fd_path + config) do
    it { should exist }
    its('content') { should match(/Generated by Chef/) }
  end
end

describe service('bareos-fd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
