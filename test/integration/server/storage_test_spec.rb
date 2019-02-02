# Validate the Storage resources and test recipes

describe package('bareos-storage') do
  it { should be_installed }
end

describe service('bareos-sd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

conf_path = '/etc/bareos/bareos-sd.d'

%w(
  autochanger
  device
  director
  messages
  ndmp
  storage
).each do |dir|
  describe directory("#{conf_path}/#{dir}") do
    it { should exist }
  end
end

%w(
  storage/bareos-sd.conf
  director/bareos-dir.conf
  director/bareos-mon.conf
  messages/Standard.conf
  device/FileStorage.conf
  device/Example1.conf
  device/Example2.conf
  device/Example3.conf
  device/Example4.conf
).each do |config|
  describe file("#{conf_path}/#{config}") do
    it { should exist }
    its('content') { should match(/Name = bareos-sd/) } if config == 'storage/bareos-sd.conf'
    its('content') { should match(/Director, who is permitted to contact this storage daemon/) } if config == 'director/bareos-dir.conf'
    its('content') { should match(/Restricted Director, used by tray-monitor to get the status of this storage daemon/) } if config == 'director/bareos-mon.conf'
    its('content') { should match(/Send all messages to the Director/) } if config == 'messages/Standard.conf'
    its('content') { should match(/File device/) } if config == 'device/FileStorage.conf'
    its('content') { should match(/Example1 Tape Drive/) } if config == 'device/Example1.conf'
    its('content') { should match(/Example2 Tape Drive/) } if config == 'device/Example2.conf'
    its('content') { should match(/Example3 Tape Drive/) } if config == 'device/Example3.conf'
    its('content') { should match(/Example4 Tape Drive/) } if config == 'device/Example4.conf'
  end
end

# package bareos-storage-tape installed
describe package('bareos-storage-tape') do
  it { should be_installed }
end

# file mtx-changer exists
describe file('/etc/bareos/mtx-changer.conf') do
  it { should exist }
end

%w(
  autochanger/autochanger-0.conf.example
  device/tapedrive-0.conf.example
).each do |config|
  describe file("#{conf_path}/#{config}") do
    it { should_not exist }
  end
end

%w(
  autochanger/test-autochanger1.conf
  autochanger/test-autochanger2.conf
).each do |config|
  describe file("#{conf_path}/#{config}") do
    it { should exist }
    its('content') { should match(/Example1/) } if config == 'test-autochanger1.conf'
    its('content') { should match(/Example2/) } if config == 'test-autochanger1.conf'
    its('content') { should match(/Example3/) } if config == 'test-autochanger2.conf'
    its('content') { should match(/Example4/) } if config == 'test-autochanger2.conf'
    its('content') { should match(/mtx-changer %c %o %S %a %d/) }
  end
end