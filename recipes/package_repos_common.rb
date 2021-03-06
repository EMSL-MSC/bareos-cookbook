if platform_family?('rhel')
  yum_repository 'bareos' do
    description node['bareos']['description']
    baseurl node['bareos']['baseurl']
    gpgkey node['bareos']['gpgkey']
    action :create
  end
  yum_repository 'bareos_contrib' do
    description node['bareos']['contrib_description']
    baseurl node['bareos']['contrib_baseurl']
    gpgkey node['bareos']['contrib_gpgkey']
    action :create
  end
elsif platform_family?('debian')
  apt_repository 'bareos' do
    uri node['bareos']['baseurl']
    components ['/']
    distribution ''
    key node['bareos']['gpgkey']
    action :add
  end
  apt_repository 'bareos_contrib' do
    uri node['bareos']['contrib_baseurl']
    components ['/']
    distribution ''
    key node['bareos']['contrib_gpgkey']
    action :add
    not_if { platform?('ubuntu') && node['platform_version'].to_f >= 16.0 }
  end
end
