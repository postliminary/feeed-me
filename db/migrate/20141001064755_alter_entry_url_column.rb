class AlterEntryUrlColumn < ActiveRecord::Migration
  def change
    change_column :entries, :url, :text
  end
end
