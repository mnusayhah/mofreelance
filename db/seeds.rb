require 'faker'

puts "🔄 Suppression des anciennes données..."

# Destroy in the correct order to prevent dependency issues
Skill.destroy_all
Education.destroy_all
Profile.destroy_all
User.destroy_all

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
end

puts "👤 Création des utilisateurs freelances..."

5.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: :freelancer
  )

  user = User.create!(
    email: Faker::Internet.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    company: Faker::Company.name,
    role: :enterprise
  )

  puts "📌 Création du profil pour #{user.email}..."

  profile = Profile.create!(
    user: user,
    title: Faker::Job.title,
    address: Faker::Address.city,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    years_of_experience: rand(1..15),
    portfolio_url: Faker::Internet.url,
    hourly_rate: rand(30..150),
    availability_status: ["available", "busy", "unavailable"].sample,
    language: ["Français", "Anglais", "Espagnol"].sample,
    #tech_skills: Array.new(3) { Faker::ProgrammingLanguage.name }  # ✅ Fix Here
  )

  puts "🎓 Ajout des formations et compétences..."

  2.times do
    profile.educations.create!(
      school: Faker::University.name,
      diploma: Faker::Educator.degree,
      start_date: Faker::Date.between(from: 5.years.ago, to: 2.years.ago),
      end_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
      localisation: Faker::Address.city
    )

    profile.skills.create!(
      job_title: Faker::Job.title,
      company: Faker::Company.name,
      start_date: Faker::Date.between(from: 10.years.ago, to: 5.years.ago),
      end_date: Faker::Date.between(from: 4.years.ago, to: Date.today),
      description: Faker::Lorem.sentence(word_count: 10),
      localisation: Faker::Address.city
    )
  end

  2.times do
    Project.create!(
      user: User.enterprise.sample, # Assign a random user
      title: Faker::Company.catch_phrase,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      budget: Faker::Number.decimal(l_digits: 4, r_digits: 2),
      status: rand(0..2), # Assuming you have different status values (e.g., 0: draft, 1: active, 2: completed)
      required_skills: Faker::Job.key_skill,
      visibility: ["public", "private"].sample,
      start_date: Faker::Date.forward(days: 10),
      end_date: Faker::Date.forward(days: 30)
    )
  end

  puts "Created 10 projects!"

  projects = Project.all
  freelancers = User.where(role: 'freelancer') # Assuming 'role' column distinguishes users

  # Create 10 shared projects
  2.times do
    SharedProject.create!(
    project: projects.sample,
    freelancer: freelancers.sample,
    status: 0, # Example: 0 = pending, 1 = accepted, 2 = completed
  )
  end

  puts "Created 10 shared projects!"
end

# Seed discussions and messages

freelancers = User.where(role: 'freelancer')
enterprises = User.where(role: 'enterprise')
projects = Project.all

if freelancers.present? && enterprises.present? && projects.present?
  5.times do
    freelancer = freelancers.sample
    enterprise = enterprises.sample
    project = projects.sample

    discussion = Discussion.create!(
      project: project,
      freelancer: freelancer,
      enterprise: enterprise
    )

    # Create messages for the discussion
    3.times do
      sender, receiver = [freelancer, enterprise].shuffle
      Message.create!(
        discussion: discussion,
        sender: sender,
        receiver: receiver,
        content: Faker::Lorem.sentence,
        read: [true, false].sample
      )
    end
  end
else
  puts "No freelancers, enterprises, or projects available. Seed them first!"
end


puts "✅ Seed terminée ! 5 freelances ont été créés avec leurs profils, compétences, formations et technologies."


# Liste de freelancers avec leurs données

freelancers = [
  { first_name: "Alice", last_name: "Durand", email: "alice@example.com", password: "password",
    title: "Graphiste Freelance", bio: "Expert en design graphique avec plus de 5 ans d'expérience.",
    address: "Port-Louis", language: "FR", tech_skills: "Photoshop, Illustrator, InDesign", hourly_rate: 500 },
  { first_name: "Bob", last_name: "Martin", email: "bob@example.com", password: "password",
    title: "Développeur Web", bio: "Spécialiste en développement Ruby on Rails et JavaScript.",
    address: "Curepipe", language: "EN", tech_skills: "Ruby, Rails, JavaScript", hourly_rate: 600 },
  { first_name: "Claire", last_name: "Petit", email: "claire@example.com", password: "password",
    title: "Consultante Marketing Digital", bio: "Aide les entreprises à améliorer leur présence en ligne.",
    address: "Quatre Bornes", language: "FR", tech_skills: "SEO, SEM, Google Analytics", hourly_rate: 550 },
  { first_name: "David", last_name: "Lefevre", email: "david@example.com", password: "password",
    title: "UX/UI Designer", bio: "Créateur d'expériences utilisateurs intuitives et modernes.",
    address: "Vacoas-Phoenix", language: "FR", tech_skills: "Sketch, Figma, Adobe XD", hourly_rate: 650 },
  { first_name: "Emma", last_name: "Laurent", email: "emma@example.com", password: "password",
    title: "Illustratrice", bio: "Passionnée d'illustration et de création visuelle.",
    address: "Port-Louis", language: "FR", tech_skills: "Procreate, Photoshop, Illustrator", hourly_rate: 480 }
]

# Création des utilisateurs et de leurs profils associés
freelancers.each do |data|
  user = User.create!(
    first_name: data[:first_name],
    last_name:  data[:last_name],
    email:      data[:email],
    password:   data[:password],
    role:       "freelancer"
  )

  Profile.create!(
    user:         user,
    title:        data[:title],
    bio:          data[:bio],
    address:      data[:address],
    availability_status: "available",
    language:     data[:language],
    tech_skills:  data[:tech_skills],
    hourly_rate:  data[:hourly_rate]
  )
end

puts "Création de #{User.where(role: 'freelancer').count} utilisateurs freelancers et de leurs profils."
