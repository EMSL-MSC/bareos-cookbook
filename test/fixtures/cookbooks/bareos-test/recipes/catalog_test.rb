# Test bareos_catalog resource
node.default['bareos']['unmanage_default_catalog'] = true
dev_config = chef_vault_item('bareos', 'config')

dev_config[:bareos][:services][:director][:catalog].each do |k, v|
  bareos_catalog k do
    catalog_config v
  end
end
