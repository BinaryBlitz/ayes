json.array!(@users) do |user|
  json.extract! user, :id, :api_token, :gender, :birthdate, :occupation, :income, :education, :relationship, :preferred_time, :country, :region, :settlement
  json.url user_url(user, format: :json)
end
