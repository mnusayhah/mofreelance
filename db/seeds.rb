ActiveRecord::Base.transaction do
  # Create Users
  enterprise = User.create!(
    email: "enterprise@example.com",
    password: "password123",
    first_name: "Enterprise",
    last_name: "Owner",
    role: 1,
    company: "TechCorp",
    phone_number: "1234567890"
  )

  freelancer = User.create!(
    email: "freelancer@example.com",
    password: "password123",
    first_name: "Freelancer",
    last_name: "Worker",
    role: 0,
    phone_number: "0987654321"
  )

  # Ensure Project is Created
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

  # Ensure Shared Project is Created
  shared_project = SharedProject.create!(
    project: project,
    freelancer: freelancer,
    status: 1
  )

  raise "Shared project not created!" if shared_project.nil?

  # Ensure Discussion is Created
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
puts "Seed data created successfully!"


# Fetch or create two freelancers
freelancer1 = User.find_or_create_by!(email: "freelancer1@example.com") do |user|
  user.password = "password123"
  user.first_name = "John"
  user.last_name = "Doe"
  user.role = "freelancer"
end

# Create profiles for each freelancer
profile1 = Profile.create!(
  user: freelancer1,
  title: "Full-Stack Developer",
  address: "123 Developer St, Remote",
  bio: "Experienced in Ruby on Rails and React.js, delivering high-quality web applications.",
  years_of_experience: 6,
  portfolio_url: "https://johndoeportfolio.com",
  hourly_rate: 60.0,
  availability_status: "Available",
  language: "English"
)


# Add skills for both freelancer profiles
Skill.create!(
  profile: profile1,
  job_title: "Software Engineer",
  company: "Tech Solutions",
  start_date: "2018-01-01",
  end_date: "2022-12-31",
  description: "Built and maintained scalable applications using Rails and React.",
  localisation: "Remote"
)

# Add education for both freelancer profiles
Education.create!(
  profile: profile1,
  school: "University of Tech",
  diploma: "BSc in Computer Science",
  start_date: "2014-09-01",
  end_date: "2018-06-01",
  localisation: "Online"
)


puts "freelancer profile with skills and education seeded successfully!"
