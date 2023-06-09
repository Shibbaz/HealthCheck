# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
name = Faker::Name.name
user = User.create!(
  name:,
  email: Faker::Internet.email(name:),
  password: 'test',
  phone_number: 667_089_810
)

post = Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [user.id])

Comment.create(id: SecureRandom.uuid, user_id: user.id, likes: [], text: 'Ah', post_id: post.id)
