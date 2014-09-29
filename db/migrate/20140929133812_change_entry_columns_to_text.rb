class ChangeEntryColumnsToText < ActiveRecord::Migration
  def change
    change_column :entries, :content, :text
    change_column :entries, :summary, :text
    change_column :entries, :categories, :text
  end
end
