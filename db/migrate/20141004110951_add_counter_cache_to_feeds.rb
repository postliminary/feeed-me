class AddCounterCacheToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :entries_count, :integer, :default => 0

    Feed.reset_column_information
    Feed.all.each do |p|
      p.update_attribute :entries_count, p.entries.length
    end
  end

  def self.down
    remove_column :feeds, :entries_count
  end
end
