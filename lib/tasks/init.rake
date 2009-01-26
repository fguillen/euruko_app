namespace :init do

  desc "Initialize all the basic stuff, usage: rake db=<mysql|sqlite> [user=user] [password=password]"
  task :all => [ 
    'init:config_files', 
    'environment', 
    'init:reset_dbs',
    'test', 
    'populate:all'
  ]
  
  
  desc "Initilizing config files"
  task :config_files do
    if !ENV.include?('db') || !['mysql','sqlite'].include?( ENV['db'] )
      raise "usage: rake db=<mysql|sqlite> [user=user] [password=password]" 
    end
    
    user      = ENV['user'].nil? ? 'root' : ENV['user']
    password  = ENV['password'].nil? ? '' : ENV['password']
    puts "initilizing database.yml with #{ENV['db']}, user: #{user}, password: #{password}..."
    FileUtils.copy_file\
      "#{RAILS_ROOT}/config/database.yml.#{ENV['db']}",
      "#{RAILS_ROOT}/config/database.yml"
      
    buffer = File.read( "#{RAILS_ROOT}/config/database.yml")
    buffer.gsub!( /<user>/, user )
    buffer.gsub!( /<password>/, password )
    
    file = File.new( "#{RAILS_ROOT}/config/database.yml", 'w' )
    file.write( buffer )
    file.flush
    file.close
      
    puts "initilizing site_keys.rb..."
    FileUtils.copy_file\
      "#{RAILS_ROOT}/config/initializers/site_keys.rb.example",
      "#{RAILS_ROOT}/config/initializers/site_keys.rb"

    puts "Please revise this file: /config/config.yml"
    puts "# /config/config.yml"
    puts File.read( "#{RAILS_ROOT}/config/config.yml" )
    
    puts "Please press enter to continue"
    $stdin.gets
  end
  
  desc "Reset databases to actual migrate state"
  task :reset_dbs => [:environment] do
    puts "Drop databases"
    Rake::Task['db:drop:all'].execute rescue nil
    
    puts "Create databases"
    Rake::Task['db:create:all'].execute
    
    puts "Run migrations"
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    ActiveRecord::Base.establish_connection(config)
    Rake::Task['db:migrate'].execute
    
    puts "Undo migrations to VERSION=0"
    ENV['VERSION']='0'
    Rake::Task['db:migrate'].execute
    
    puts "Re-Run migrations"
    Rake::Task['db:migrate'].execute
      
    puts "Clone test db"
    Rake::Task['db:test:clone'].execute
  end
  
  # desc "Run migrations"
  # task :run_migrations2 => [:environment] do
  #   Rake::Task['db:create:all'].execute
  #   
  #   config = ActiveRecord::Base.configurations[RAILS_ENV]
  #   ActiveRecord::Base.establish_connection(config)
  #   ActiveRecord::Base.connection
  #   
  #   Rake::Task['db:migrate'].execute
  # end
  # 
  # desc "Run migrations"
  # task :run_migrations => [:environment] do
  #   entries_before = ENV.entries
  #   Rake::Task['db:create:all'].execute
  #   entries_before.each {|en| ENV[en.first]=en.last}
  #   Rake::Task['db:migrate'].execute
  # end
end