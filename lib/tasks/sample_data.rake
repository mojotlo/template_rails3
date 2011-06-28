require "faker"

namespace :db do
  desc "Fill database with sample data"#for errors
  task :populate  => :environment do #environment allows rake access to current env and the User methods
    Rake::Task['db:reset'].invoke#resets the db
    User.create!(:name => "Example User",
                  :email  => 'example@example.com',
                  :password  => 'foobar',
                  :password_confirmation  => "foobar")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password = "password"
      User.create!(:name => name,
                  :email  => email,
                  :password  => password,
                  :password_confirmation  => password)
    end
  end
end