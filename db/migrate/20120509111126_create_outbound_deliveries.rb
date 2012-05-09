class CreateOutboundDeliveries < ActiveRecord::Migration
  def self.up
    create_table :outbound_deliveries do |t|
      t.integer :delivery_no
      t.integer :sto_no
      t.string  :destination_plant      
      t.column  :created_at, "timestamp with local time zone"
      t.column  :updated_at, "timestamp with local time zone"
    end
    add_index :outbound_deliveries, [:delivery_no, :sto_no, :destination_plant], :unique => true
  end

  def self.down
    drop_table :outbound_deliveries
  end
end
