require 'spec_helper'

describe 'bareos::director_common' do
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
        %w(bareos bareos_contrib).each do |repo|
          it "adds #{repo} repository" do
            if platform =~ /^(ubuntu|debian)$/
              expect(chef_run).to add_apt_repository(repo)
            else
              expect(chef_run).to create_yum_repository(repo)
            end
          end
        end
        it 'installs bareos-director package' do
          expect(chef_run).to install_package('bareos-director')
        end
        it 'creates director config dirs with the default action' do
          %w(
            catalog
            client
            console
            counter
            director
            fileset
            job
            jobdefs
            messages
            pool
            profile
            schedule
            storage
          ).each do |dir|
            expect(chef_run).to create_directory("director_#{dir}_dir")
          end
          expect(chef_run).to create_directory('/etc/bareos/bareos-dir.d')
        end

        it 'enables and starts the bareos-dir service' do
          expect(chef_run).to enable_service('bareos-dir')
          expect(chef_run).to start_service('bareos-dir')
        end
      end
    end
  end
end
