require_relative 'spec_helper'

describe 'rs-storage::volume' do
  let(:chef_runner) do
    ChefSpec::Runner.new do |node|
      node.set['rightscale_volume']['data_storage']['device'] = '/dev/sda'
      node.set['rightscale_backup']['data_storage']['devices'] = ['/dev/sda']
    end
  end
  let(:nickname) { chef_run.node['rs-storage']['device']['nickname'] }
  let(:detach_timeout) do
    chef_runner.converge(described_recipe).node['rs-storage']['device']['detach_timeout'].to_i
  end

  before do
    stub_command('[ `rs_config --get decommission_timeout` -eq 300 ]').and_return(false)
  end

  context 'rs-storage/restore/lineage is not set' do
    let(:chef_run) { chef_runner.converge(described_recipe) }

    it 'sets the decommission timeout' do
      expect(chef_run).to run_execute("set decommission timeout to #{detach_timeout}").with(
        command: "rs_config --set decommission_timeout #{detach_timeout}",
      )
    end

    it 'creates a new volume and attaches it' do
      expect(chef_run).to create_rightscale_volume(nickname).with(
        size: 10,
        options: {},
      )
      expect(chef_run).to attach_rightscale_volume(nickname)
    end

    it 'formats the volume and mounts it' do
      expect(chef_run).to create_filesystem(nickname).with(
        fstype: 'ext4',
        mkfs_options: '-F',
        mount: '/mnt/storage',
      )
      expect(chef_run).to enable_filesystem(nickname)
      expect(chef_run).to mount_filesystem(nickname)
    end

    context 'iops is set to 100' do
      let(:chef_run) do
        chef_runner.node.set['rs-storage']['device']['iops'] = 100
        chef_runner.converge(described_recipe)
      end

      it 'creates a new volume with iops set to 100 and attaches it' do
        expect(chef_run).to create_rightscale_volume(nickname).with(
          size: 10,
          options: {iops: 100},
        )
        expect(chef_run).to attach_rightscale_volume(nickname)
      end
    end
  end

  context 'rs-storage/restore/lineage is set' do
    let(:chef_runner_restore) do
      chef_runner.node.set['rs-storage']['restore']['lineage'] = 'testing'
      chef_runner
    end
    let(:chef_run) do
      chef_runner_restore.converge(described_recipe)
    end
    let(:device) { chef_run.node['rightscale_volume'][nickname]['device'] }

    it 'creates a volume from the backup' do
      expect(chef_run).to restore_rightscale_backup(nickname).with(
        lineage: 'testing',
        timestamp: nil,
        size: 10,
        options: {},
      )
    end

    it 'mounts and enables the restored volume' do
      expect(chef_run).to mount_mount(device).with(
        fstype: 'ext4',
      )
      expect(chef_run).to enable_mount(device)
    end

    context 'iops is set to 100' do
      let(:chef_run) do
        chef_runner_restore.node.set['rs-storage']['device']['iops'] = 100
        chef_runner_restore.converge(described_recipe)
      end

      it 'creates a volume from the backup with iops' do
        expect(chef_run).to restore_rightscale_backup(nickname).with(
          lineage: 'testing',
          timestamp: nil,
          size: 10,
          options: {iops: 100},
        )
      end
    end

    context 'timestamp is set' do
      let(:timestamp) { Time.now.to_i }
      let(:chef_run) do
        chef_runner_restore.node.set['rs-storage']['restore']['timestamp'] = timestamp
        chef_runner_restore.converge(described_recipe)
      end

      it 'creates a volume from the backup with the timestamp' do
        expect(chef_run).to restore_rightscale_backup(nickname).with(
          lineage: 'testing',
          timestamp: timestamp,
          size: 10,
          options: {},
        )
      end
    end
  end
end
