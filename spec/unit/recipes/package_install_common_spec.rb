require 'spec_helper'

describe 'bareos::package_install_common' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: platform, version: version
          ) do |_node, _server|
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'installs bareos package' do
          expect(chef_run).to install_package('bareos-common')
        end
      end
    end
  end
end
