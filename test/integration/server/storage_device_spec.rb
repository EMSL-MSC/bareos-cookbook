# Verify the test of the bareos_storage_device resource
conf_path = '/etc/bareos'

%w(
  FileStorage.conf
  Example1.conf
  Example2.conf
  Example3.conf
  Example4.conf
).each do |dev_config|
  describe file("#{conf_path}/bareos-sd.d/device/#{dev_config}") do
    it { should exist }
    its('content') { should match(/File device/) } if dev_config == 'FileStorage.conf'
    its('content') { should match(/Example1 Tape Drive/) } if dev_config == 'Example1.conf'
    its('content') { should match(/Example2 Tape Drive/) } if dev_config == 'Example2.conf'
    its('content') { should match(/Example3 Tape Drive/) } if dev_config == 'Example3.conf'
    its('content') { should match(/Example4 Tape Drive/) } if dev_config == 'Example4.conf'
  end
end
