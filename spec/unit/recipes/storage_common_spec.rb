require 'spec_helper'

describe 'bareos::storage_common' do
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
        # %w(bareos bareos_contrib).each do |repo|
        #   it "adds #{repo} repository" do
        #     if platform =~ /^(ubuntu|debian)$/
        #       expect(chef_run).to add_apt_repository(repo)
        #     else
        #       expect(chef_run).to create_yum_repository(repo)
        #     end
        #   end
        # end
        it 'installs bareos-storage package' do
          expect(chef_run).to install_package('bareos-storage')
        end
        it 'creates storage config dirs with the default action' do
          %w(
            autochanger
            device
            director
            messages
            ndmp
            storage
          ).each do |dir|
            expect(chef_run).to create_directory("storage_#{dir}_dir")
          end
          expect(chef_run).to create_directory('/etc/bareos/bareos-sd.d')
        end
        it 'enables and starts the bareos-sd service' do
          expect(chef_run).to enable_service('bareos-sd')
          expect(chef_run).to start_service('bareos-sd')
        end
      end
    end
  end
end
