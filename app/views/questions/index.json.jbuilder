json.array!(@questions) do |question|
  json.extract! question, :id, :epigraph, :content, :created_at
  json.url question_url(question, format: :json)
end
