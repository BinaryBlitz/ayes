json.array! @favorites do |favorite|
  json.extract! favorite, :id, :user_id, :question_id, :created_at
end
