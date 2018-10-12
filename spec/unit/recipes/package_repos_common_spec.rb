require 'spec_helper'

describe 'bareos::package_repos_common' do
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
        %w(bareos bareos_contrib).each do |repo|
          if platform =~ /^(ubuntu|debian)$/
            it "adds #{repo} apt_repository" do
              expect(chef_run).to add_apt_repository(repo)
            end
          else
            it "creates #{repo} yum_repository" do
              expect(chef_run).to create_yum_repository(repo)
            end
          end
        end
      end
    end
  end
end
