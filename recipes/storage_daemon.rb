include_recipe 'bareos::package_repos'
package 'bareos-storage'

directory '/etc/bareos/bareos-sd.d' do
  path '/etc/bareos/bareos-sd.d'
  owner 'bareos'
  group 'bareos'
  mode '0750'
  action :create
end

%w(autochanger device director messages ndmp storage).each do |sd_dir|
  directory "create_global_storage_daemon_#{sd_dir}_dir" do
    path "/etc/bareos/bareos-sd.d/#{sd_dir}"
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end
end

sd_config = if node['bareos']['use_attribute_configs'] == false
              data_bag_content = chef_vault_item(
                node['bareos']['service_data_bag'],
                node['bareos']['storage_daemon']['data_bag_item']
              )
              data_bag_content[:bareos][:services][:storage_daemon]
            else
              node['bareos']['services']['storage_daemon']
            end

unless sd_config[:daemon].nil?
  sd_config[:daemon].each do |daemon_name, daemon_config|
    next if daemon_config.nil?
    template "#{daemon_name}_config" do
      source 'bareos-sd.erb'
      path "/etc/bareos/bareos-sd.d/storage/#{daemon_name}.conf"
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        daemon_config: daemon_config,
        daemon_name: daemon_name
      )
      notifies :restart, 'service[bareos-sd]', :delayed
    end
  end
end

unless sd_config[:director].nil?
  sd_config[:director].each do |director_name, director_config|
    next if director_config.nil?
    template "#{director_name}_config" do
      source 'storage_daemon_director.erb'
      path "/etc/bareos/bareos-sd.d/director/#{director_name}.conf"
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        director_config: director_config,
        director_name: director_name
      )
      notifies :restart, 'service[bareos-sd]', :delayed
    end
  end
end

unless sd_config[:mon].nil?
  sd_config[:mon].each do |mon_name, mon_config|
    next if mon_config.nil?
    template "#{mon_name}_config" do
      source 'storage_daemon_mon.erb'
      path "/etc/bareos/bareos-sd.d/director/#{mon_name}.conf"
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        mon_config: mon_config,
        mon_name: mon_name
      )
      notifies :restart, 'service[bareos-sd]', :delayed
    end
  end
end

unless sd_config[:messages].nil?
  sd_config[:messages].each do |messages_name, messages_config|
    next if messages_config.nil?
    template "#{messages_name}_config" do
      source 'storage_daemon_messages.erb'
      path "/etc/bareos/bareos-sd.d/messages/#{messages_name}.conf"
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        messages_config: messages_config,
        messages_name: messages_name
      )
      notifies :restart, 'service[bareos-sd]', :delayed
    end
  end
end

default_filestorage = {
  'Media Type' => 'File',
  'Archive Device' => '/var/lib/bareos/storage',
  'LabelMedia' => 'yes;',
  'Random Access' => 'yes;',
  'AutomaticMount' => 'yes;',
  'RemovableMedia' => 'no;',
  'AlwaysOpen' => 'no;',
  'Description' => '"File device. A connecting Director must have the same Name and MediaType."',
}
bareos_storage_device 'FileStorage' do
  device_config default_filestorage
  not_if { node['bareos']['storage']['disable_default_filestorage'] }
  notifies :restart, 'service[bareos-sd]', :delayed
end

# Start and enable SD service
service 'bareos-sd' do
  supports [status: true, restart: true, reload: false]
  action [:enable, :start]
end
