require 'spec_helper'

describe 'bareos::autochanger_common' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ) do |_node, _server|
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'installs bareos-storage-tape with the default action' do
          expect(chef_run).to install_package('bareos-storage-tape')
        end
        it 'executes mtx-changer script with the default action' do
          expect(chef_run).to run_execute('mtx-changer script')
        end
        it 'creates mtx-changer config template with the default action' do
          expect(chef_run).to create_template('mtx-changer config')
        end
        it 'deletes unnecessary example configs' do
          %w(
            /etc/bareos/bareos-sd.d/autochanger/autochanger-0.conf.example
            /etc/bareos/bareos-sd.d/device/tapedrive-0.conf.example
          ).each do |example_conf|
            expect(chef_run).to delete_file(example_conf)
          end
        end
      end
    end
  end
end
