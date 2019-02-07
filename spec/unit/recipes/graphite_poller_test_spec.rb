require 'spec_helper'

describe 'bareos-test::graphite_poller_test' do
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
        unless platform =~ /^(ubuntu)$/ && version =~ /^(16.04|18.04)$/
          it 'converges successfully' do
            expect { chef_run }.to_not raise_error
          end
          it 'installs python requirements for graphite_poller' do
            expect(chef_run).to run_bash('install_bareos_graphite_poller_requirements')
          end
          it 'deploys graphite_poller plugins' do
            expect(chef_run).to create_bareos_graphite_poller('bareos_graphite_1')
            expect(chef_run).to create_bareos_graphite_poller('bareos_graphite_2')
          end
        end
      end
    end
  end
end
