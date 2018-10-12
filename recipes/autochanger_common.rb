# Manage mtx-changer config http://doc.bareos.org/master/html/bareos-manual-main-reference.html#QQ2-1-467
package 'bareos-storage-tape'

execute 'mtx-changer script' do
  command '/usr/bin/bareos/scripts/mtx-changer'
  creates '/etc/bareos/mtx-changer.conf'
  action :run
end

template 'mtx-changer config' do
  source 'mtx_changer.erb'
  path '/etc/bareos/mtx-changer.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

%w(
  /etc/bareos/bareos-sd.d/autochanger/autochanger-0.conf.example
  /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example
).each do |example_conf|
  file example_conf do
    action :delete
  end
end
