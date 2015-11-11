json.array!(@questions) do |question|
  json.extract! question, :id, :epigraph, :content, :created_at

  json.answered current_user.answers.find_by(question: question).present?

  json.answers do
    json.positive question.answers.positive.count
    json.negative question.answers.negative.count
    json.neutral question.answers.neutral.count
  end
end
