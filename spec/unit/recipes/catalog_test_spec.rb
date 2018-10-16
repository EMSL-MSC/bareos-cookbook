require 'spec_helper'

describe 'bareos-test::catalog_test' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: platform, version: version
          ) do |node, _server|
            node.normal['bareos']['use_custom_catalog'] = true
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
