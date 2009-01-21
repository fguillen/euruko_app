Instalar la aplicación
----------------------
### Instalarla

    git clone git://github.com/fguillen/euruko_app.git  

### External dependencies
		gem install mocha
		gem install faker
		gem install will-paginate
		gem install Roman2K-rails-test-serving -s http://gems.github.com # testing accelerator

### Iniciar Configuraciones

    cd euruko_app
    cp config/database.yml.example config/database.yml 
    cp config/initializers/site_keys.rb.example config/initializers/site_keys.rb
    vim config/config.yml

### Iniciar BD

    rake db:create:all
    rake db:migrate
    rake db:test:clone

### Correr tests

    rake

### Popularizar la BD con datos de pruba

    rake populate:random

### Añadir usuario admin

    rake populate:admin



