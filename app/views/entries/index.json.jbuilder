json.array!(@entries) do |entry|
  json.extract! entry, :id, :feed_id, :title, :url, :author, :content, :summary, :published, :updated, :categories, :entry_id
  json.url entry_url(entry, format: :json)
end
