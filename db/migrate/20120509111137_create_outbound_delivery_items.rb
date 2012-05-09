class CreateOutboundDeliveryItems < ActiveRecord::Migration
  def self.up
    create_table :outbound_delivery_items do |t|
      t.references :outbound_delivery
      t.string :material_code
      t.string :book_no
      t.column :created_at, "timestamp with local time zone"
      t.column :updated_at, "timestamp with local time zone"
    end
    add_index :outbound_delivery_items, :book_no, :unique => true
    add_index :outbound_delivery_items, :material_code
  end

  def self.down
    drop_table :outbound_delivery_items
  end
end
