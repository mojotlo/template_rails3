
Factory.define :user do |user|
  user.name                     "Michael Hartl"
  user.email                    "mhartl@exampl.com"
  user.password                 "foobar"
  user.password_confirmation    "foobar"
end

Factory.define :profile do |profile|
  profile.about                 "This is a story about me"
  profile.association           :user
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

