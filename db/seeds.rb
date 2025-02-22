require 'faker'

ActiveRecord::Base.transaction do
  # Create an Enterprise User
  enterprise = User.create!(
    email: "enterprise@example.com",
    password: "password123",
    first_name: "Enterprise",
    last_name: "Owner",
    role: 1,
    company: "TechCorp",
    phone_number: "1234567890"
  )

  # Create 5 Freelancers with Profiles, Skills, and Education
  5.times do |i|
    freelancer = User.create!(
      email: "freelancer#{i + 1}@example.com",
      password: "password123",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      role: 0,
      phone_number: Faker::PhoneNumber.cell_phone
    )
# Create Profile without skills initially
profile = Profile.create!(
  user: freelancer,
  title: Faker::Job.title,
  address: Faker::Address.city,
  bio: Faker::Lorem.paragraph(sentence_count: 2),
  years_of_experience: rand(1..20),
  portfolio_url: Faker::Internet.url,
  hourly_rate: rand(20..100),
  availability_status: ["available", "busy", "unavailable"].sample,
  language: Faker::Nation.language
)

# Create 3-5 associated skills and attach them to the profile
skills = []
rand(3..5).times do
  start_date = Faker::Date.backward(days: rand(1000..4000))
  end_date = start_date + rand(365..1460) # Ensure end_date is after start_date
  skills << Skill.create!(
    profile_id: profile.id,
    job_title: Faker::Job.position,
    company: Faker::Company.name,
    start_date: start_date,
    end_date: end_date,
    description: Faker::Job.key_skill,
    localisation: Faker::Address.city
  )
end

# Attach the created skills to the profile
  profile.skills_id << skill.id

    # Create 1-2 education records for each profile
    rand(1..2).times do
      Education.create!(
        profile_id: profile.id,
        school: Faker::University.name,
        diploma: Faker::Educator.course_name,
        start_date: Faker::Date.backward(days: 2500),
        end_date: Faker::Date.backward(days: 1000),
        localisation: Faker::Address.city
      )
    end
  end

  # Create a Sample Project
  project = Project.create!(
    user: enterprise,
    title: "Website Development",
    description: "Build a modern web app using Rails and React.",
    budget: 5000,
    status: "ongoing",
    required_skills: "Ruby on Rails, React",
    visibility: "public",
    start_date: Date.today,
    end_date: Date.today + 30.days
  )

  raise "Project not created!" if project.nil?

  # Assign the First Freelancer to the Project
  freelancer = User.where(role: 0).first

  shared_project = SharedProject.create!(
    project: project,
    freelancer: freelancer,
    status: 1
  )

  raise "Shared project not created!" if shared_project.nil?

  # Create Discussion
  discussion = Discussion.create!(
    project: project,
    freelancer: freelancer,
    enterprise: enterprise
  )

  raise "Discussion not created!" if discussion.nil?

  # Create Messages
  Message.create!(discussion: discussion, sender: enterprise, receiver: freelancer, content: "Hello Freelancer!", read: false)
  Message.create!(discussion: discussion, sender: freelancer, receiver: enterprise, content: "Hi Enterprise!", read: false)
end

puts "✅ Seed data created successfully!"
