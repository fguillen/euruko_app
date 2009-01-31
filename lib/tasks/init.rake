namespace :init do

  desc "Initialize all the basic stuff, usage: rake db=<mysql|sqlite> [user=user] [password=password]"
  task :all do
    if !ENV.include?('db') || !['mysql','sqlite'].include?( ENV['db'] )
      raise "usage: rake init:all db=<mysql|sqlite> [user=user] [password=password]"  #  [populate=<test|development|production>]
    end
    
    Rake::Task['init:config_files'].invoke
    Rake::Task['environment'].invoke
    Rake::Task['init:reset_dbs'].invoke
    Rake::Task['test'].invoke
    
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    ActiveRecord::Base.establish_connection(config)
    
    Rake::Task['populate:all'].invoke
  end
  
  
  desc "Initilizing config files"
  task :config_files do
    if !ENV.include?('db') || !['mysql','sqlite'].include?( ENV['db'] )
      raise "usage: rake init:config_files db=<mysql|sqlite> [user=user] [password=password]" 
    end
    
    require 'utils'
    
    user      = ENV['user'].nil? ? 'root' : ENV['user']
    password  = ENV['password'].nil? ? '' : ENV['password']
    puts "initilizing database.yml with #{ENV['db']}, user: #{user}, password: #{password}..."
    FileUtils.copy_file\
      "#{RAILS_ROOT}/config/database.yml.#{ENV['db']}",
      "#{RAILS_ROOT}/config/database.yml"
      
    file_gsub( "#{RAILS_ROOT}/config/database.yml", /<user>/, user )
    file_gsub( "#{RAILS_ROOT}/config/database.yml", /<password>/, password )
      
    puts "initilizing site_keys.rb..."
    FileUtils.copy_file\
      "#{RAILS_ROOT}/config/initializers/site_keys.rb.example",
      "#{RAILS_ROOT}/config/initializers/site_keys.rb"
    
    file_gsub( "#{RAILS_ROOT}/config/initializers/site_keys.rb", /<site_key>/, Utils.site_key_generator )

    puts "Please revise this file: /config/config.yml"
    puts "# /config/config.yml"
    puts File.read( "#{RAILS_ROOT}/config/config.yml" )
    
    puts "Please press enter to continue"
    $stdin.gets
  end
  
  desc "Reset databases to actual migrate state"
  task :reset_dbs => [:environment] do
    puts "Drop databases"
    Rake::Task['db:drop:all'].invoke rescue nil
    
    puts "Create databases"
    Rake::Task['db:create:all'].invoke
    
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    ActiveRecord::Base.establish_connection(config)
    
    puts "Run migrations"
    Rake::Task['db:migrate'].invoke
    
    # puts "Undo migrations to VERSION=0"
    # ENV['VERSION']='0'
    # Rake::Task['db:migrate'].invoke
    # 
    # puts "Re-Run migrations"
    # Rake::Task['db:migrate'].invoke
      
    puts "Clone test db"
    Rake::Task['db:test:clone'].invoke
  end
  
  # desc "Run migrations"
  # task :run_migrations2 => [:environment] do
  #   Rake::Task['db:create:all'].invoke
  #   
  #   config = ActiveRecord::Base.configurations[RAILS_ENV]
  #   ActiveRecord::Base.establish_connection(config)
  #   ActiveRecord::Base.connection
  #   
  #   Rake::Task['db:migrate'].invoke
  # end
  # 
  # desc "Run migrations"
  # task :run_migrations => [:environment] do
  #   entries_before = ENV.entries
  #   Rake::Task['db:create:all'].invoke
  #   entries_before.each {|en| ENV[en.first]=en.last}
  #   Rake::Task['db:migrate'].invoke
  # end
  
  def file_gsub( file_path, regex, substitution )
    buffer = File.read( file_path )
    buffer.gsub!( regex, substitution )
    
    file = File.new( file_path, 'w' )
    file.write( buffer )
    file.flush
    file.close
  end  
end