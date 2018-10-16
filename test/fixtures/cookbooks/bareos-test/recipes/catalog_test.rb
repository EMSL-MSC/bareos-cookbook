# Test bareos_catalog resource
node.default['bareos']['use_custom_catalog'] = true

bareos_catalog 'Verbose Catalog Example for Bareos' do
  name 'MyCatalog'
  catalog_config(
    dbname: 'bareos',
    dbuser: 'bareos',
    dbpassword: ''
  )
  catalog_backend 'postgresql'
  template_name 'catalog.erb'
  template_cookbook 'bareos'
  action :create
end
