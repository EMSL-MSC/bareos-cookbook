# Verify the test of the bareos_storage_autochanger resource
conf_path = '/etc/bareos'

# package bareos-storage-tape installed
describe package('bareos-storage-tape') do
  it { should be_installed }
end

# file mtx-changer exists
describe file("#{conf_path}/mtx-changer.conf") do
  it { should exist }
end

%w(
  autochanger/autochanger-0.conf.example
  device/tapedrive-0.conf.example
).each do |example_conf|
  describe file("#{conf_path}/bareos-sd.d/#{example_conf}") do
    it { should_not exist }
  end
end

%w(
  test-autochanger1.conf
  test-autochanger2.conf
).each do |ac_config|
  describe file("#{conf_path}/bareos-sd.d/autochanger/#{ac_config}") do
    it { should exist }
    its('content') { should match(/Example1/) } if ac_config == 'test-autochanger1.conf'
    its('content') { should match(/Example2/) } if ac_config == 'test-autochanger1.conf'
    its('content') { should match(/Example3/) } if ac_config == 'test-autochanger2.conf'
    its('content') { should match(/Example4/) } if ac_config == 'test-autochanger2.conf'
    its('content') { should match(/mtx-changer %c %o %S %a %d/) }
  end
end
