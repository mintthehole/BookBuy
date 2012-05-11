class AddSapCodesToNoisbntitle < ActiveRecord::Migration
  def self.up
    add_column :noisbntitles, :sap_rm, :string, :limit => 1, :null => false, :default => 'N'
    add_column :noisbntitles, :sap_fg, :string, :limit => 1, :null => false, :default => 'N'
    add_column :noisbntitles, :sap_bom, :string, :limit => 1, :null => false, :default => 'N'
    add_column :noisbntitle_versions, :sap_rm, :string, :limit => 1
    add_column :noisbntitle_versions, :sap_fg, :string, :limit => 1
    add_column :noisbntitle_versions, :sap_bom, :string, :limit => 1
  end

  def self.down
    remove_column :noisbntitles, :sap_rm
    remove_column :noisbntitles, :sap_fg
    remove_column :noisbntitles, :sap_bom
    remove_column :noisbntitle_versions, :sap_rm
    remove_column :noisbntitle_versions, :sap_fg
    remove_column :noisbntitle_versions, :sap_bom
  end
end
