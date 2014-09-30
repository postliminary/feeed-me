class AddIndexToUpdatedAt < ActiveRecord::Migration
  def change
    add_index :entries, :updated_at
    add_index :feeds, :updated_at
  end
end
