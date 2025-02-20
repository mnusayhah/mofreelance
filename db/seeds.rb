# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "🔄 Resetting database..."
# Destroy old data
Message.destroy_all
Discussion.destroy_all
SharedProject.destroy_all
Project.destroy_all
Profile.destroy_all
User.destroy_all
puts "👤 Creating Freelancers & Enterprises..."
# Create Two Users for Testing
enterprise = User.create!(
  email: "enterprise@example.com",
  password: "password",
  first_name: "John",
  last_name: "Doe",
  role: :enterprise,
  company: "TechCorp"
)
puts "Enterprise Created"
freelancer = User.create!(
  email: "freelancer@example.com",
  password: "password",
  first_name: "Alice",
  last_name: "Smith",
  role: :freelancer
)
puts "Freelancer Created"

# Create Profiles
Profile.create!(
  user: enterprise,
  title: "Tech Company Owner",
  bio: Faker::Lorem.paragraph,
  address: Faker::Address.city,
  availability_status: "available"
)
Profile.create!(
  user: freelancer,
  title: "Ruby on Rails Developer",
  bio: Faker::Lorem.paragraph,
  address: Faker::Address.city,
  availability_status: "available"
)

puts "Profile Created"

# Create a Project
project = Project.create!(
  user: enterprise,
  title: "Build a Freelancer Platform",
  description: "We need a full-stack developer to build a marketplace for freelancers.",
  budget: 2000,
  status: "open",
  required_skills: "Ruby on Rails, JavaScript",
  visibility: "private",
  start_date: Date.today,
  end_date: Date.today + 30
)

<<<<<<< HEAD
puts "Project Created"
=======
  Profile.create!(
    user: user,
    title: Faker::Job.title,
    address: Faker::Address.city,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    profile_picture: 
    years_of_experience: rand(1..15),
    portfolio_url: Faker::Internet.url,
    hourly_rate: rand(30..150),
    availability_status: ["available", "busy", "unavailable"].sample,
    language: ["Français", "Anglais", "Espagnol"].sample
  )
end
>>>>>>> master

# Share the Project with Freelancer
shared_project = SharedProject.create!(
  project: project,
  freelancer: freelancer,
  status: :accepted # Freelancer has already accepted the project
)

puts "Shared project Created"

# Create Discussion for the Project
discussion = Discussion.create!(
  project: project,
  freelancer: freelancer,
  enterprise: enterprise
)
puts "Discussion Created"

# ✅ **Create messages WITHOUT triggering `broadcast_message`**
Message.new(
  discussion: discussion,
  sender_id: enterprise.id,
  receiver_id: freelancer.id,
  content: "Hello Alice! Are you available for this project?"
).save!(validate: false)

Message.new(
  discussion: discussion,
  sender_id: freelancer.id,
  receiver_id: enterprise.id,
  content: "Yes, I am! What are the requirements?"
).save!(validate: false)

puts "✅ Seeding complete!"
puts "📌 TEST USERS:"
puts "Enterprise Login: enterprise@example.com | Password: password"
puts "Freelancer Login: freelancer@example.com | Password: password"
