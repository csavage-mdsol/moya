class DroptDrdsTable < ActiveRecord::Migration
  def up
    drop_table :drds
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
