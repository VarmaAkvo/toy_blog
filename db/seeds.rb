# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

varma = User.create(name: 'varma', email: 'varma@example.com', password: '123456', password_confirmation: '123456')
# Tags
Faker::Lorem.words(50).each do |tag|
  Tag.create(name: tag)
end
tag_ids = Tag.all.ids
# Users
30.times do
  name = Faker::Name.unique.name.gsub(/\s+/, '_').downcase
  email = name.downcase + '@example.com'
  user = User.create(name: name, email: email, password: '123456', password_confirmation: '123456')

  tags = Tag.where(id: tag_ids.shuffle.take(3)).pluck(:name).join(' ')
  user.create_tags(tags)
end
users = User.all
user_ids = users.ids
# Articles
users.each do |user|
  10.times do
    title = Faker::Lorem.sentence(3, true, 4)
    content = Faker::Lorem.paragraph(3)
    article = user.articles.create(title: title, content: content)

    tags = Tag.where(id: tag_ids.shuffle.take(5)).pluck(:name).join(' ')
    article.create_tags(tags)
  end
end
# Comments
Article.all.each do |article|
  floor = 0
  User.where(id: user_ids.shuffle.take(6)).each do |user|
    floor += 1
    content = Faker::Lorem.sentences.join('')
    article.comments.create(user_id: user.id, content: content, floor: floor)
  end
end
# Replies
Comment.all.each do |comment|
  User.where(id: user_ids.shuffle.take(6)).each do |user|
    content = Faker::Lorem.sentence
    comment.replies.create(user_id: user.id, content: content)
  end
end
# Follow
first_group_ids = user_ids.shuffle.take(15)
second_group_ids = user_ids - first_group_ids
User.where(id: first_group_ids).each do |fg_user|
  User.where(id: second_group_ids).each do |sg_user|
    fg_user.follow sg_user
    sg_user.follow fg_user
  end
end
# BlogPunishments
(user_ids - [varma.id]).shuffle.take(20).each do |punished_id|
  varma.blog_punishments.create(punished_id: punished_id, expire_time: 30.days.after)
end
# Punishments
(user_ids - [varma.id]).shuffle.take(20).each do |user_id|
  Punishment.create(user_id: user_id, expire_time: 30.days.after)
end
