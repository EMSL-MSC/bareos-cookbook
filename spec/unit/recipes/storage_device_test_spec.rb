require 'spec_helper'

describe 'bareos-test::storage_device_test' do
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
                      "device": {
                        "Example1": {
                          "AlwaysOpen": 'yes;',
                          "ArchiveDevice": '/dev/tape/by-id/scsi-IBMTAPEDRIVE1-nst',
                          "Autochanger": 'yes',
                          "AutomaticMount": 'yes;',
                          "Autoselect": 'no',
                          "Description": '"Example1 Tape Drive."',
                          "DeviceType": 'tape',
                          "DriveIndex": '0',
                          "Maximum Changer Wait": '30 minutes',
                          "Maximum Concurrent Jobs": '1',
                          "Maximum File Size": '20G',
                          "Maximum Job Spool Size": '50G',
                          "Maximum Rewind Wait": '30 minutes',
                          "Maximum Spool Size": '50G',
                          "MediaType": 'LTO-4',
                          "Spool Directory": '/spool',
                        },
                        "Example2": {
                          "AlwaysOpen": 'yes;',
                          "ArchiveDevice": '/dev/tape/by-id/scsi-IBMTAPEDRIVE2-nst',
                          "Autochanger": 'yes',
                          "AutomaticMount": 'yes;',
                          "Autoselect": 'no',
                          "Description": '"Example2 Tape Drive."',
                          "DeviceType": 'tape',
                          "DriveIndex": '1',
                          "Maximum Changer Wait": '30 minutes',
                          "Maximum Concurrent Jobs": '1',
                          "Maximum File Size": '20G',
                          "Maximum Job Spool Size": '50G',
                          "Maximum Rewind Wait": '30 minutes',
                          "Maximum Spool Size": '50G',
                          "MediaType": 'LTO-4',
                          "Spool Directory": '/spool',
                        } } } } } })
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
