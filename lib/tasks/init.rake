namespace :init do

  desc "Initialize all the basic stuff"
  task :all => [ 'init:config_files', 'environment', 'init:drop_databases', 'db:create:all', 'db:migrate', 'db:test:clone', 'test', 'populate:all'] do
  end
  
  desc "drop all databases if exists"
  task :drop_databases => [:environment] do
    puts "Drop databases"
    Rake::Task['db:drop:all'].execute rescue nil
  end
  
  
  desc "Initilizing config files"
  task :config_files do
    puts ENV.inspect
    unless ENV.include?('db') || !['mysql','sqlite'].include?( ENV['db'] )
      raise "usage: rake db=<mysql|sqlite>" 
    end
    
    puts "initilizing database.yml with #{ENV['db']}..."
    FileUtils.copy_file\
      "#{RAILS_ROOT}/config/database.yml.#{ENV['db']}",
      "#{RAILS_ROOT}/config/database.yml"
      
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
end