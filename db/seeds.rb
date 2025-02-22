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
end

puts "✅ Seed terminée ! 5 freelances ont été créés avec leurs profils, compétences, formations et technologies."
