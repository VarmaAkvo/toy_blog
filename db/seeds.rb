# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#encrypted_password = Devise::Encryptor.digest(User, 123456)
#password: '123456', password_confirmation: '123456'
varma = User.create(name: 'varma', email: 'varma@example.com', password: '123456', password_confirmation: '123456')
Faker::Lorem.words(20).each do |tag|
  Tag.create(name: tag)
end
tag_ids = (1..20).to_a
puts 1
9.times do
  name = Faker::Name.unique.name.gsub(/\s+/, '_')
  email = Faker::Internet.unique.email
  #avatar = Faker::Avatar.image
  user = User.create(name: name, email: email, password: '123456', password_confirmation: '123456')

  tags = Tag.where(id: tag_ids.shuffle.take(3)).pluck(:name).join(' ')
  user.create_tags(tags)
end
user_ids = (1..10).to_a
puts 2
10.times do
  title = Faker::Lorem.sentence(3, true, 4)
  content = Faker::Lorem.paragraphs
  article = varma.articles.create(title: title, content: content)

  tags = Tag.where(id: tag_ids.shuffle.take(3)).pluck(:name).join(' ')
  article.create_tags(tags)
end
puts 3
floor = 0
User.where(id: user_ids.shuffle.take(6)).each do |user|
  floor += 1
  varma.articles.each do |article|
    content = Faker::Lorem.sentences.join('')
    article.comments.create(user_id: user.id, content: content, floor: floor)
  end
end
puts 4
User.where(id: user_ids.shuffle.take(6)).each do |user|
  Comment.all.each do |comment|
    content = Faker::Lorem.sentence
    comment.replies.create(user_id: user.id, content: content)
  end
end
