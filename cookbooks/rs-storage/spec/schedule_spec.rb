require_relative 'spec_helper.rb'

describe 'rs-storage::schedule' do
  context 'rs-storage/schedule/enable is true' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rs-storage']['schedule']['enable'] = true
        node.set['rs-storage']['backup']['lineage'] = 'testing'
        node.set['rs-storage']['schedule']['hour'] = '10'
        node.set['rs-storage']['schedule']['minute'] = '30'
      end.converge(described_recipe)
    end
    let(:lineage) { chef_run.node['rs-storage']['backup']['lineage'] }

    it 'creates a crontab entry' do
      expect(chef_run).to create_cron("backup_schedule_#{lineage}").with(
        minute: chef_run.node['rs-storage']['schedule']['minute'],
        hour: chef_run.node['rs-storage']['schedule']['hour'],
        command: "rs_run_recipe --policy 'rs-storage::backup' --name 'rs-storage::backup'"
      )
    end
  end

  context 'rs-storage/schedule/enable is false' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rs-storage']['schedule']['enable'] = false
        node.set['rs-storage']['backup']['lineage'] = 'testing'
      end.converge(described_recipe)
    end
    let(:lineage) { chef_run.node['rs-storage']['backup']['lineage'] }

    it 'deletes a crontab entry' do
      expect(chef_run).to delete_cron("backup_schedule_#{lineage}").with(
        command: "rs_run_recipe --policy 'rs-storage::backup' --name 'rs-storage::backup'"
      )
    end
  end

  context 'rs-storage/schedule/hour or rs-storage/schedule/minute missing' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rs-storage']['backup']['lineage'] = 'testing'
        node.set['rs-storage']['schedule']['enable'] = true
        node.set['rs-storage']['schedule']['hour'] = '10'
      end.converge(described_recipe)
    end
    let(:lineage) { chef_run.node['rs-storage']['backup']['lineage'] }

    it 'raises an error' do
      expect { chef_run }.to raise_error(
        RuntimeError,
        'rs-storage/schedule/hour and rs-storage/schedule/minute inputs should be set'
      )
    end
  end
end
