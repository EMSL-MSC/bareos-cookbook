require 'spec_helper'

describe 'bareos-test::storage_autochanger_test' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ) do |_node, server|
            server.create_data_bag(
              'bareos',
              'config' => {
                'bareos' => {
                  'services' => {
                    'storage_daemon' => {
                      'autochanger' =>  {
                        'test-autochanger1' =>  {
                          'Changer Command' =>  [
                            '"/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"',
                          ],
                          'Changer Device' =>  [
                            '/dev/tape/by-id/scsi-IBMLIBRARY1',
                          ],
                          'Description' =>  [
                            '"test-autochanger1 config."',
                          ],
                          'Device' =>  %w(
                            Example1
                            Example2
                          ),
                        },
                        'test-autochanger2' =>  {
                          'Changer Command' =>  [
                            '"/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"',
                          ],
                          'Changer Device' =>  [
                            '/dev/tape/by-id/scsi-IBMLIBRARY2',
                          ],
                          'Description' =>  [
                            '"test-autochanger2 config."',
                          ],
                          'Device' =>  %w(
                            Example3
                            Example4
                          ),
                        },
                      } } } } })
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
