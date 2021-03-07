# frozen_string_literal: true

# Initial admin
Employee.create!({
  full_name:    'Administrator',
  email:        'admin@company.com',
  password:     'admin',
  gender:       'male',
  department:   'Administration',
  phone_number: '+123456790',
  address:      'Bogor, Indonesia',
  is_admin:     true
})

Employee.create!({
  full_name:    'John Doe',
  email:        'john.doe@company.com',
  password:     'john.doe',
  gender:       'male',
  department:   'R&D',
  phone_number: '+123456790',
  address:      'Bogor, Indonesia',
  is_admin:     false
})

attributes = []
98.times do |_|
  name  = Faker::Name.name
  email = Faker::Internet.email(name: name, domain: 'company.com')
  now   = Time.now

  attributes.push({
    full_name:       name,
    email:           email,
    password_digest: BCrypt::Password.create("#{email.gsub('@company.com', '')}", cost: 1).to_s,
    gender:          Faker::Gender.binary_type.downcase,
    department:      Faker::Job.field,
    phone_number:    Faker::PhoneNumber.phone_number,
    address:         Faker::Address.full_address,
    created_at:      now,
    updated_at:      now
  })
end

Employee.insert_all!(attributes)
