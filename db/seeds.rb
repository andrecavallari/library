# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.where(email: 'john@domain.com').first_or_create do |user|
  user.name = 'John Doe'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = :librarian
end

(1..5).each do |i|
  User.create!(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    password_confirmation: 'password123',
    role: :member
  )
end

(1..10).each do |i|
  Book.create!(
    copies: rand(1..5),
    title: Faker::Book.unique.title,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    isbn: Faker::Code.unique.isbn,
  )
end
