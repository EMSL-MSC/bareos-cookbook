require 'spec_helper'

describe 'bareos-test::catalog_test' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ) do |_node, server|
            server.create_data_bag(
              'bareos',
              'config' => {
                'bareos' => {
                  'services' => {
                    "director": {
                      "catalog": {
                        "MyCatalog": {
                          "dbname": 'bareos',
                          "dbpassword": '',
                          "dbuser": 'bareos',
                        } } } } } })
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'creates and bootstraps the defined Bareos Catalog' do
          expect(chef_run).to create_bareos_catalog('MyCatalog')
        end
      end
    end
  end
end
