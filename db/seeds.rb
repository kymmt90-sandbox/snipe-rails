require 'ffaker'

10.times do
  password = 'passw0rd'
  User.create(
    name:     FFaker::Name.name,
    email:    FFaker::Internet.email,
    password: password,
    password_confirmation: password
  )
end

User.all.each do |user|
  10.times do
    user.snippets.create(
      title: FFaker::Lorem.words.join(' '),
      content: FFaker::HTMLIpsum.body
    )
  end
end

User.all.each do |user|
  other = nil
  loop do
    other = User.all.to_a.sample
    break if user != other
  end
  other.snippets.to_a.sample(10).each do |snippet|
    snippet.comments.create(
      comment_author_id: user.id,
      content: FFaker::Lorem.paragraph
    )
  end
end

User.all.each do |user|
  snippets = Snippet.all.to_a.sample(5)
  snippets.each do |snippet|
    snippet.stars.create(user_id: user.id)
  end
end
