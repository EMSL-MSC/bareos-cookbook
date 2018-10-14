require 'spec_helper'

describe 'bareos-test::storage_custom_resource_tests' do
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
                      },
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
                        },
                      },
                      'storage' => {
                        'bareos-sd' => {
                          'Description' => ['\"Default bareos-sd config.\"'],
                          'Maximum Concurrent Jobs' => ['20'],
                          'SDPort' => ['9103'],
                        },
                      },
                      'director' =>  {
                        'bareos-dir' =>  {
                          'Description' =>  ['"Director"'],
                          'Password' =>  ['SUPERNOTSECRETPASS'],
                        },
                      },
                      'messages' =>  {
                        'Standard' =>  {
                          'Description' =>  ['"Send all"'],
                          'Director' =>  ['bareos-dir = all'],
                        },
                      },
                      'mon' =>  {
                        'bareos-mon' =>  {
                          'Description' =>  ['"Restricted Director"'],
                        },
                      },
                    },
                  },
                },
              })
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'creates storage storage configs' do
          expect(chef_run).to create_bareos_storage_storage('bareos-sd')
        end
        it 'creates storage director config' do
          expect(chef_run).to create_bareos_storage_director('bareos-dir')
        end
        it 'creates storage mon configs' do
          expect(chef_run).to create_bareos_storage_mon('bareos-mon')
        end
        it 'creates storage messages configs' do
          expect(chef_run).to create_bareos_storage_messages('Standard')
        end
        it 'creates storage device configs' do
          expect(chef_run).to create_bareos_storage_device('FileStorage')
          expect(chef_run).to create_bareos_storage_device('Example1')
          expect(chef_run).to create_bareos_storage_device('Example2')
        end
        it 'creates storage autochanger configs' do
          expect(chef_run).to create_bareos_storage_autochanger('test-autochanger1')
          expect(chef_run).to create_bareos_storage_autochanger('test-autochanger2')
        end
      end
    end
  end
end
