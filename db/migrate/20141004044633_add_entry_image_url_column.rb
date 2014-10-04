class AddEntryImageUrlColumn < ActiveRecord::Migration
  def change
    add_column :entries, :image_url, :text
  end
end
