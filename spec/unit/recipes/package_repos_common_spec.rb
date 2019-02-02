require 'spec_helper'

describe 'bareos::package_repos_common' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'adds bareos repository' do
          if platform =~ /^(ubuntu|debian)$/
            expect(chef_run).to add_apt_repository('bareos')
          else
            expect(chef_run).to create_yum_repository('bareos')
          end
        end
        it 'adds bareos_contrib repository' do
          if platform =~ /^(ubuntu|debian)$/
            if version =~ /^(16.04|18.04)$/
              expect(chef_run).to_not add_apt_repository('bareos_contrib')
            else
              expect(chef_run).to add_apt_repository('bareos_contrib')
            end
          else
            expect(chef_run).to create_yum_repository('bareos_contrib')
          end
        end
      end
    end
  end
end
