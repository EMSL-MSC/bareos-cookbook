# directory
describe package('python-bareos') do
  it { should be_installed }
end

%w(
bareos_graphite_1a
bareos_graphite_1b
).each do |plugin|
  describe directory("/opt/#{plugin}/source") do
    it { should exist }
  end

  describe file("/opt/#{plugin}/source/bareos-graphite-poller.py") do
    it { should exist }
    its('sha256sum') { should eq '3c25e4b5bc6c76c8539ee105d53f9fb25fb2d7759645c4f5fa26e6ff7eb020b3' }
  end

  describe file("/opt/#{plugin}/source/graphite-poller.conf") do
    it { should exist }
    its('content') { should match(/name=director/) }
    its('content') { should match(/port=2003/) }
  end

  describe crontab('bareos') do
    it { should exist }
    its('commands') { should include(/#{plugin}/) }
  end
end

describe directory("/opt/bareos_virtualenv") do
  it { should exist }
end

%w(python-bareos django requests).each do |pip_pkg|
  describe pip(pip_pkg, "/opt/bareos_virtualenv/bin/pip") do
    it { should be_installed }
  end
end
