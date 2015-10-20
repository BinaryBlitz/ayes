u = User.create!
u.update!(api_token: 'foobar')

q = Question.create!(epigraph: 'Lorem ipsum', content: 'Dolor sit amet')

Admin.create!(email: 'foo@bar.com', password: 'qwerty123')
