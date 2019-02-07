# Setup basic postgresql server environment for testing
postgresql_repository 'bareos' do
  version '9.4'
end

postgresql_server_install 'package' do
  version '9.4'
  action [:install, :create]
end

find_resource(:service, 'postgresql') do
  extend PostgresqlCookbook::Helpers
  service_name lazy { platform_service_name }
  supports restart: true, status: true, reload: true
  action [:enable, :start]
end
