# Test the storage_daemon recipe
conf_path = '/etc/bareos'

%w(autochanger device director messages ndmp storage).each do |d_dir|
  describe directory("#{conf_path}/bareos-sd.d/#{d_dir}") do
    it { should exist }
  end
end

describe service('bareos-sd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

%w(
  storage/bareos-sd.conf
  director/bareos-dir.conf
  director/bareos-mon.conf
  messages/Standard.conf
).each do |sd_config|
  describe file("#{conf_path}/bareos-sd.d/#{sd_config}") do
    it { should exist }
    its('content') { should match(/Name = bareos-sd/) } if sd_config == 'storage/bareos-sd.conf'
    its('content') { should match(/Director, who is permitted to contact this storage daemon/) } if sd_config == 'director/bareos-dir.conf'
    its('content') { should match(/Restricted Director, used by tray-monitor to get the status of this storage daemon/) } if sd_config == 'director/bareos-mon.conf'
    its('content') { should match(/Send all messages to the Director/) } if sd_config == 'messages/Standard.conf'
  end
end
