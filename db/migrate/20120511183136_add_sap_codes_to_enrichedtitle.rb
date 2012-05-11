class AddSapCodesToEnrichedtitle < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :sap_rm, :string, :limit => 1, :null => false, :default => 'N'
    add_column :enrichedtitles, :sap_fg, :string, :limit => 1, :null => false, :default => 'N'
    add_column :enrichedtitles, :sap_bom, :string, :limit => 1, :null => false, :default => 'N'
    add_column :enrichedtitle_versions, :sap_rm, :string, :limit => 1
    add_column :enrichedtitle_versions, :sap_fg, :string, :limit => 1
    add_column :enrichedtitle_versions, :sap_bom, :string, :limit => 1
  end

  def self.down
    remove_column :enrichedtitles, :sap_rm
    remove_column :enrichedtitles, :sap_fg
    remove_column :enrichedtitles, :sap_bom
    remove_column :enrichedtitle_versions, :sap_rm
    remove_column :enrichedtitle_versions, :sap_fg
    remove_column :enrichedtitle_versions, :sap_bom
  end
end
