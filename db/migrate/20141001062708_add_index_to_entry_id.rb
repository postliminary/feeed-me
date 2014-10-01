class AddIndexToEntryId < ActiveRecord::Migration
  def change
    add_index :entries, :entry_id
  end
end
