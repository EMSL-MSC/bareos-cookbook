require 'spec_helper'

describe 'bareos::default' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          runner = ChefSpec::ServerRunner.new(platform: platform, version: version)
          runner.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'includes the package recipes' do
          expect(chef_run).to include_recipe('bareos::package_repos')
          expect(chef_run).to include_recipe('bareos::package_install')
        end
      end
    end
  end
end
