json.array!(@questions) do |question|
  json.extract! question, :id, :epigraph, :content, :created_at

  json.answered current_user.answers.find_by(question: question).present?

  json.url question_url(question, format: :json)
end
