class AddEntryPublishedIndex < ActiveRecord::Migration
  def change
    add_index :entries, :published
  end
end
