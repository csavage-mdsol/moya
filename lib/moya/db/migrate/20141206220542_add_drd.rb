class AddDrd < ActiveRecord::Migration
  def change
    create_table :drds, id: false do |t|
      t.string :uuid, limit: 36, primary: true
      t.string :name
      t.string :status
      t.string :kind
      t.string :leviathan_uuid
      t.string :leviathan_url
      t.datetime :built_at

      t.timestamps
    end
  end
end
