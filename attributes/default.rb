# Repository
default['bareos']['version'] = '18.2'
default['bareos']['url'] = 'http://download.bareos.org/bareos/release'
default['bareos']['contrib_url'] = 'http://download.bareos.org/bareos/contrib'

if platform_family?('rhel')
  default['bareos']['repository_name'] = 'bareos'
  default['bareos']['description'] = "Bareos #{node['bareos']['version']}"
  default['bareos']['contrib_repository_name'] = 'bareos_contrib'
  default['bareos']['contrib_description'] = "Bareos #{node['bareos']['version']} contrib"
end

case node['platform']
when 'debian'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/Debian_#{node['platform_version'].to_i}.0/Release.key"
  default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/Debian_#{node['platform_version'].to_i}.0/"
  default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/Debian_#{node['platform_version'].to_i}.0/Release.key"
when 'ubuntu'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/xUbuntu_#{node['platform_version']}/Release.key"
  default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/xUbuntu_#{node['platform_version']}/"
  default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/xUbuntu_#{node['platform_version']}/Release.key"
when 'centos'
  default['bareos']['baseurl'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/"
  default['bareos']['gpgkey'] = "#{node['bareos']['url']}/#{node['bareos']['version']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
  default['bareos']['contrib_baseurl'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/"
  default['bareos']['contrib_gpgkey'] = "#{node['bareos']['contrib_url']}/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
end

default['bareos']['unmanage_default_catalog'] = false
default['bareos']['packages'] = %w(bareos)
