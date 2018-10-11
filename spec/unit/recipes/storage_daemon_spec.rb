require 'spec_helper'

describe 'bareos::storage_daemon' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ) do |node, server|
            node.normal['bareos']['use_attribute_configs'] = false
            node.normal['bareos']['service_data_bag'] = 'bareos'
            node.normal['bareos']['storage_daemon']['data_bag_item'] = 'config'
            server.create_data_bag(
              'bareos',
              'config' => {
                'bareos' => {
                  'services' => {
                    'storage_daemon' => {
                      'daemon' => {
                        'bareos-sd' => {
                          'Description' => ['\"Default bareos-sd config.\"'],
                          'Maximum Concurrent Jobs' => ['20'],
                          'SDPort' => ['9103'],
                        },
                      },
                      'director' =>  {
                        'bareos-dir' =>  {
                          'Description' =>  ['"Director"'],
                          'Password' =>  ['SUPERNOTSECRETPASS'],
                        },
                      },
                      'messages' =>  {
                        'Standard' =>  {
                          'Description' =>  ['"Send all"'],
                          'Director' =>  ['bareos-dir = all'],
                        },
                      },
                      'mon' =>  {
                        'bareos-mon' =>  {
                          'Description' =>  ['"Restricted Director"'],
                        } } } } } })
          end.converge(described_recipe)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
