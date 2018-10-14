# Validate the storage_daemon resources and test recipes
describe package('bareos-director') do
  it { should be_installed }
end

describe service('bareos-dir') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

conf_path = '/etc/bareos'

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
  describe directory("#{conf_path}/bareos-dir.d/#{dir}") do
    it { should exist }
  end
end
