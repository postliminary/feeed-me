class AddSummaryTextToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :summary_text, :text
  end
end
