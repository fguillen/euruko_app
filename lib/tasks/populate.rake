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
        :text         => 'The default administrator',
        :public_profile => true
      )
    
    user.role = User::ROLE[:ADMIN]
    user.save!
    
    user.activate!
    
    puts "Admin created:"
    puts "login: #{user.login}"
    puts "pass:  #{user.password}"
    puts "email: #{user.email}"

  end
  
  desc "Create the random user"
  task :random_user => :environment do
    require 'mocha'
    require 'faker'
    
    # Not emails
    UserObserver.any_instance.stubs(:after_create).returns(true)
    UserObserver.any_instance.stubs(:after_save).returns(true)
    
    password = Faker::Lorem.words.join()
    
    user = 
      User.create!(
        :name               => Faker::Name.name,
        :login              => Faker::Internet.user_name,
        :email              => Faker::Internet.free_email,
        :password           => password,
        :password_confirmation => password,
        :text               => Faker::Lorem.paragraphs.join("\n"),
        :public_profile     => true
      )
    user.activate!
    
    puts "User created:"
    puts "login: #{user.login}"
    puts "pass: #{user.password}"
    puts "email: #{user.email}"
  end

  desc "Populate with random elements"
  task :random => :environment do
    require 'mocha'
    require 'faker'
    puts "Populate the environment #{RAILS_ENV} with random..."
    
    # delete everything
    puts "Deleting Everything..."
    Attendee.delete_all
    Vote.delete_all
    Comment.delete_all
    CartsEvent.delete_all
    Cart.delete_all
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
      begin

        password = Faker::Lorem.words.join()
      
        user = 
          User.create(
            :name               => Faker::Name.name,
            :login              => Faker::Internet.user_name + num.to_s,
            :email              => Faker::Internet.free_email,
            :password           => password,
            :password_confirmation => password,
            :text               => Faker::Lorem.paragraphs.join("\n"),
            :personal_web_name  => Faker::Lorem.words.join(" "),
            :personal_web_url   => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}",
            :company_name       => Faker::Lorem.words.join(" "),
            :company_url        => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}",
            :public_profile     => (1 == Kernel.rand(2))
          )
        user.activate!

      rescue Exception => e
      end
    end
    
    puts "... #{User.count} users created"

    
    puts "Creating Rooms..."
    (1..5).each do |num|
      Room.create( 
        :name   => Faker::Lorem.words(2).join(" "),
        :notes  => Faker::Lorem.paragraph
      )
    end
    puts "... #{Room.count} rooms created"

    # not send emails on paper creation
    Paper.any_instance.stubs(:notify_by_mail).returns(true)
    
    puts "Creating Papers..."
    (1..50).each do |num|
      paper =
        Paper.new(
          :title        => Faker::Lorem.sentence,
          :description  => Faker::Lorem.paragraphs.join("\n")
        )
      paper.creator = User.random(1)
      paper.save
        
      paper.family  = Paper::FAMILY.values.rand
      paper.minutes = Kernel.rand(101)
      paper.date    = random_datetime( '2009/04/10 08:00', '2009/04/14 21:00' )
      paper.room    = Room.random(1)
      paper.status  = Paper::STATUS.values.rand
      paper.save
    end
    
    puts "... #{Paper.count} papers created"
    
    
    puts "Creating Events..."
    (1..5).each do |num|
      Event.create(
        :name         => Faker::Lorem.sentence, 
        :description  => Faker::Lorem.paragraphs.join("\n"),
        :price_cents  => Kernel.rand(10001),
        :capacity     => Kernel.rand(101)
      )
    end
    puts "... #{Event.count} events created"

    
    puts "Creating Speakers..."
    (1..50).each do |num|
      Speaker.create(
        :user      => User.public_profile.random(1),
        :paper     => Paper.random(1)
      )
    end
    puts "... #{Speaker.count} speakers created"

    
    puts "Creating Resources..."
    (1..150).each do |num|
      Resource.create(
        :user   => User.random(1),
        :paper  => Paper.random(1), 
        :url    => "http://#{Faker::Internet.domain_name}/#{Faker::Lorem.words.join('/')}",
        :name   => Kernel.rand(2) == 0 ? nil : Faker::Lorem.sentence
      )
    end
    puts "... #{Resource.count} resources created"

    
    
    # puts "Creating Carts..."
    # (1..50).each do |num|
    #   Cart.create(
    #     :user   => User.random(1),
    #     :event  => Event.random(1) 
    #   )
    # end
    # puts "... #{Cart.count} carts created"

    
    puts "Creating Comments..."
    (1..200).each do |num|
      Comment.create(
        :user   => User.random(1),
        :paper  => Paper.random(1),
        :text   => Faker::Lorem.paragraph
      )
    end
    puts "... #{Comment.count} comments created"

    
    puts "Creating Votes..."
    (1..100).each do |num|
      Vote.create(
        :user     => User.random(1),
        :paper    => Paper.random(1),
        :points   => Kernel.rand(6)
      )
    end
    puts "... #{Vote.count} votes created"

    
    puts "Creating Attendees..."
    (1..100).each do |num|
      Attendee.create(
        :user     => User.random(1),
        :paper    => Paper.random(1)
      )
    end
    puts "... #{Attendee.count} attendees created"

  end
  
  desc "Populate with random elements, and admin, and a random user"
  task :all => [:random, :admin, :random_user]
  
  def random_datetime( date_ini = '1970/01/01 10:10', date_end = '2010/01/01 10:10' )
    time_ini_int = Time.parse( date_ini ).to_i
    time_end_int = Time.parse( date_end ).to_i
    
    time_random_int = Kernel.rand( time_end_int - time_ini_int ) + time_ini_int
    
    return Time.at( time_random_int )
  end
end