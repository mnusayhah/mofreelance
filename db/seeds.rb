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

ActiveRecord::Base.transaction do
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
      last_name: data[:last_name],
      email: data[:email],
      password: data[:password],
      role: "freelancer"
    )

    Profile.create!(
      user: user,
      title: data[:title],
      bio: data[:bio],
      address: data[:address],
      language: data[:language],
      tech_skills: data[:tech_skills],
      hourly_rate: data[:hourly_rate]
    )
  end

  puts "Création de #{User.where(role: 'freelancer').count} utilisateurs freelancers et de leurs profils."
end
