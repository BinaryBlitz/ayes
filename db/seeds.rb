# User
u = User.create!
u.update!(api_token: 'foobar')

# Questions
20.times do
  Question.create!(
    epigraph: FFaker::Lorem.sentence,
    content: FFaker::Lorem.sentence
  )
end

# Admin
Admin.create!(email: 'foo@bar.com', password: 'qwerty123')

# Push notifications
app = Rpush::Apns::App.new
app.name = 'ios_app'
app.certificate = File.read(Rails.root.join('config', 'pushcert.pem'))
app.environment = 'sandbox'
app.connections = 1
app.save!
