class AddAllDrdAttributes < ActiveRecord::Migration
  def change
    add_column :drds, :old_status, :string
    add_column :drds, :size, :string
    add_column :drds, :location, :string
    add_column :drds, :location_detail, :string
    add_column :drds, :destroyed_status, :boolean, default: 0
    add_column :drds, :repair_history_url, :string
  end
end
