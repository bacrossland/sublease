class CreateLodgers < ActiveRecord::Migration
  def change
    create_table :lodgers do |t|
      t.string :name
      t.integer :tenant_id
      t.timestamps null: false
    end
  end
end
