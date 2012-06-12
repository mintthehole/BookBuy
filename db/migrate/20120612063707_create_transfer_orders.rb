class CreateTransferOrders < ActiveRecord::Migration
  def self.up
    create_table :transfer_orders do |t|
      
      t.string :warehouse, :null => false
      t.string :to_date, :null => false
      t.integer :to_number, :null => false
      t.integer :to_item, :null => false
      t.integer :movement_type, :null => false
      t.integer :material_type, :null => false
      t.string :material_code, :null => false
      t.string :storage_location, :null => false
      t.string :storage_bin, :null => false
      t.integer :required_quantity, :null => false
      
      t.integer :picked_quantity, :null => false, :default => 0
      
      t.column :created_at, "timestamp with local time zone", :null => false
      t.column :updated_at, "timestamp with local time zone", :null => false      
    end
    
    add_index :transfer_orders, [:to_number, :to_item], :unique => true
    add_index :transfer_orders, [:to_date, :storage_bin, :material_code]
  end

  def self.down
    drop_table :transfer_orders
  end
end
