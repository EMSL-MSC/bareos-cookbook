# Validate the storage_daemon resources and test recipes
%w(
  bareos-director
  bareos-database-common
  bareos-database-tools
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe service('bareos-dir') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

conf_path = '/etc/bareos/bareos-dir.d'

%w(
  catalog
  client
  console
  counter
  director
  fileset
  job
  jobdefs
  messages
  pool
  profile
  schedule
  storage
).each do |dir|
  describe directory("#{conf_path}/#{dir}") do
    it { should exist }
  end
end

%w(
  catalog/MyCatalog.conf
).each do |config|
  describe file("#{conf_path}/#{config}") do
    it { should exist }
    its('content') { should match(/Name = MyCatalog/) } if config == 'catalog/MyCatalog.conf'
  end
end
