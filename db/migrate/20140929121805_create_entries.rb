class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id
      t.string :title
      t.string :url
      t.string :author
      t.string :content
      t.string :summary
      t.datetime :published
      t.datetime :updated
      t.string :categories
      t.string :entry_id

      t.timestamps
    end
  end
end
