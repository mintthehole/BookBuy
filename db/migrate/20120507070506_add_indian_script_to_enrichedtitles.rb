class AddIndianScriptToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :t_title, :string
    add_column :enrichedtitles, :t_author, :string
    add_column :enrichedtitle_versions, :t_title, :string
    add_column :enrichedtitle_versions, :t_author, :string
  end

  def self.down
    remove_column :enrichedtitles, :t_title
    remove_column :enrichedtitles, :t_author
    remove_column :enrichedtitle_versions, :t_title
    remove_column :enrichedtitle_versions, :t_author
  end
end