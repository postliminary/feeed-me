class AddIndexToFeedTitle < ActiveRecord::Migration
  def change
    add_index :feeds, :title
  end
end
