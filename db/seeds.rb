u = User.create!
u.update!(api_token: 'foobar')

20.times do
  Question.create!(
    epigraph: FFaker::Lorem.sentence,
    content: FFaker::Lorem.sentence
  )
end

Admin.create(email: 'foo@bar.com', password: 'qwerty123')
