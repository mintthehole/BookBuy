class AddSapGroupsToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :sap_matkl, :string
    add_column :categories, :sap_ekgrp, :string
  end

  def self.down
    remove_column :categories, :sap_matkl
    remove_column :categories, :sap_ekgrp
  end
end
