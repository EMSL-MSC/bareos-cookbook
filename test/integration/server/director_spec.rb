# Validate the storage_daemon resources and test recipes
%w(
  bareos-director
  bareos-database-common
  bareos-database-tools
  bareos-database-postgresql
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

describe directory('/etc/dbconfig-common') do
  it { should exist }
end

%w(
  config
  bareos-database-common.conf
).each do |config|
  describe file("/etc/dbconfig-common/#{config}") do
    it { should exist }
    its('content') { should match(/dbc_install='false'/) } if config == 'bareos-database-common.conf'
    its('content') { should match(/dbc_upgrade='false'/) } if config == 'bareos-database-common.conf'
    its('content') { should match(/dbc_remove='false'/) } if config == 'bareos-database-common.conf'
    its('content') { should match(/dbc_remember_admin_pass='false'/) } if config == 'config'
    its('content') { should match(/dbc_remote_questions_default='false'/) } if config == 'config'
  end
end

%w(
  .dbcreated_MyCatalog
  .dbtabcreated_MyCatalog
  .dbtabupdated_MyCatalog
  .dbprivgranted_MyCatalog
).each do |state|
  describe file("/var/lib/bareos/#{state}") do
    it { should exist }
  end
end
