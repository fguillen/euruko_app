namespace :populate do
  desc "Create the default admin"
  task :admin => :environment do
    require 'mocha'
    
    # Not emails
    UserObserver.any_instance.stubs(:after_create).returns(true)
    UserObserver.any_instance.stubs(:after_save).returns(true)
    
    user = 
      User.create!(
        :name         => 'Administrator',
        :login        => 'admin',
        :email        => 'admin@email.com',
        :password     => 'adminpass',
        :password_confirmation => 'adminpass',
        :role         => User::ROLE[:ADMIN],
        :text         => 'The default adeministrator',
        :public_profile => true
      )
      
    user.activate!
    
    puts "Admin created:"
    puts "login: #{user.login}"
    puts "pass: #{user.password}"
  end

  desc "Populate with random elements"
  task :random => :environment do
    require 'mocha'
    require 'faker'
    puts "Populate with random..."
    
    # delete everything
    puts "Deleting Everything..."
    Attend.delete_all
    Vote.delete_all
    Comment.delete_all
    Payment.delete_all
    Resource.delete_all
    Speaker.delete_all
    Event.delete_all
    Paper.delete_all
    Room.delete_all
    User.delete_all

    puts "Creating Users..."
    
    # Not emails
    UserObserver.any_instance.stubs(:after_create).returns(true)
    UserObserver.any_instance.stubs(:after_save).returns(true)
    
    (1..100).each do |num|
      password = Faker::Lorem.words.join()
      
      user = 
        User.create(
          :name               => Faker::Name.name,
          :login              => Faker::Internet.user_name + num.to_s,
          :email              => Faker::Internet.free_email,
          :password           => password,
          :password_confirmation => password,
          :role               => [User::ROLE[:ADMIN], User::ROLE[:USER]].rand,
          :text               => Faker::Lorem.paragraphs.join("\n"),
          :personal_web_name  => Faker::Lorem.words.join(" "),
          :personal_web_url   => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}",
          :company_name       => Faker::Lorem.words.join(" "),
          :company_url        => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}",
          :public_profile     => (1 == Kernel.rand(2))
        )
      user.activate!
    end
    
    puts "... #{User.count} users created"

    
    puts "Creating Rooms..."
    (1..5).each do |num|
      Room.create( :name => Faker::Lorem.words(1) )
    end
    puts "... #{Room.count} rooms created"

    puts "Creating Papers..."
    (1..50).each do |num|
      Paper.create(
        :title        => Faker::Lorem.sentence,
        :description  => Faker::Lorem.paragraphs.join("\n"),
        :family       => Paper::FAMILY.values.rand,
        :status       => Paper::STATUS.values.rand
      )
    end
    puts "... #{Paper.count} papers created"
    
    
    puts "Creating Events..."
    (1..5).each do |num|
      Event.create(
        :name         => Faker::Lorem.sentence, 
        :description  => Faker::Lorem.paragraphs,
        :price_cents  => Kernel.rand(30001)
      )
    end
    puts "... #{Event.count} events created"

    
    puts "Creating Speakers..."
    (1..50).each do |num|
      Speaker.create(
        :user      => User.find(:first, :order => 'rand()'),
        :paper     => Paper.find(:first, :order => 'rand()')
      )
    end
    puts "... #{Speaker.count} speakers created"

    
    puts "Creating Resources..."
    (1..150).each do |num|
      Resource.create(
        :user   => User.find(:first, :order => 'rand()'),
        :paper  => Paper.find(:first, :order => 'rand()'), 
        :url    => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}"
      )
    end
    puts "... #{Resource.count} resources created"

    
    
    puts "Creating Payments..."
    (1..50).each do |num|
      Payment.create(
        :user   => User.find(:first, :order => 'rand()'),
        :event  => Event.find(:first, :order => 'rand()') 
      )
    end
    puts "... #{Payment.count} payments created"

    
    puts "Creating Comments..."
    (1..200).each do |num|
      Comment.create(
        :user   => User.find(:first, :order => 'rand()'),
        :paper  => Paper.find(:first, :order => 'rand()'),
        :text   => Faker::Lorem.paragraph
      )
    end
    puts "... #{Comment.count} comments created"

    
    puts "Creating Votes..."
    (1..100).each do |num|
      Vote.create(
        :user     => User.find(:first, :order => 'rand()'),
        :paper    => Paper.find(:first, :order => 'rand()'),
        :points   => Kernel.rand(6)
      )
    end
    puts "... #{Vote.count} votes created"

    
    puts "Creating Attends..."
    (1..100).each do |num|
      Attend.create(
        :user     => User.find(:first, :order => 'rand()'),
        :paper    => Paper.find(:first, :order => 'rand()')
      )
    end
    puts "... #{Attend.count} attends created"

  end
  
end