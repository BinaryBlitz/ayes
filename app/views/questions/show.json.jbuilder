json.extract! @question, :id, :epigraph, :content, :created_at

json.answers do
  json.positive @question.answers.positive.count
  json.negative @question.answers.negative.count
  json.neutral @question.answers.neutral.count
end
