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
          expect(chef_run).to include_recipe('bareos::package_repos_common')
          expect(chef_run).to include_recipe('bareos::package_install_common')
        end
        %w(bareos bareos_contrib).each do |repo|
          it "adds #{repo} repository" do
            if platform =~ /^(ubuntu|debian)$/
              expect(chef_run).to add_apt_repository(repo)
            else
              expect(chef_run).to create_yum_repository(repo)
            end
          end
        end
        it 'installs bareos with the default action' do
          expect(chef_run).to install_package('bareos')
        end
      end
    end
  end
end
