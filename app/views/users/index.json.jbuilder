json.array!(@users) do |user|
  json.extract! user, :id, :api_token, :gender, :birthdate, :city, :occupation, :income, :education, :relationship, :preferred_time, :country, :region
  json.url user_url(user, format: :json)
end
