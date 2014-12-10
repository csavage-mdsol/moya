class RemoveBuiltAt < ActiveRecord::Migration
  def change
    remove_column :drds, :built_at
  end
end
