class AddSapGroupsToLanguage < ActiveRecord::Migration
  def self.up
    add_column :languages, :sap_matkl, :string
    add_column :languages, :sap_ekgrp, :string
  end

  def self.down
    remove_column :languages, :sap_matkl
    remove_column :languages, :sap_ekgrp
  end
end
