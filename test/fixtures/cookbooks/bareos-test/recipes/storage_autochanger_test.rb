# Test bareos_storage_autochanger resource
ac_config = chef_vault_item('bareos', 'config')

ac_config[:bareos][:services][:storage_daemon][:autochanger].each do |k, v|
  bareos_storage_autochanger k do
    autochanger_config v
  end
end
