class AddDrdsWithBinaryUuids < ActiveRecord::Migration
  def change
    create_table :drds, id: false do |t|
      t.uuid :id, primary_key: true
      t.string :name
      t.string :status
      t.string :kind
      t.uuid :leviathan_uuid
      t.string :leviathan_url

      t.timestamps
    end
  end
end
