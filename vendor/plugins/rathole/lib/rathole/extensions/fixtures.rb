class Fixtures < YAML::Omap
  def delete_existing_fixtures_with_rathole
    delete_existing_fixtures_without_rathole if Rathole.delete_incrementally?
  end
  
  def insert_fixtures_with_rathole
    now = Time.now.to_s(:db) # TODO: utc?

    # allow a standard key to be used for doing defaults in YAML
    delete(assoc("DEFAULTS"))
    
    # track any HABTM join tables we need to insert later
    habtm_fixtures = Hash.new do |h, habtm|
      h[habtm] = HabtmFixtures.new(@connection, habtm.options[:join_table], nil, nil)
    end

    each do |label, yaml_fixture|
      row = yaml_fixture.to_hash

      # fill in timestamp columns if they aren't specified
      timestamp_column_names.each do |name|
        row[name] = now unless row.key?(name)
      end
      
      # interpolate the fixture label
      row.each do |key, value|
        row[key] = label if value == "$LABEL"
      end
      
      if model_class
        # generate a primary key
        row[primary_key_name] = ::Fixtures.identify(label)
                    
        model_class.reflect_on_all_associations.each do |association|
          case association.macro
          when :belongs_to
            if value = row.delete(association.name.to_s)
              fk_name = (association.options[:foreign_key] || "#{association.name}_id").to_s
              row[fk_name] = ::Fixtures.identify(value)
            end
          when :has_and_belongs_to_many
            if (targets = row.delete(association.name.to_s))
              targets = targets.is_a?(Array) ? targets : targets.split(/\s*,\s*/)
              join_fixtures = habtm_fixtures[association]

              targets.each do |target|
                join_fixtures["#{label}_#{target}"] = Fixture.new(
                  { association.primary_key_name => ::Fixtures.identify(label),
                    association.association_foreign_key => ::Fixtures.identify(target) }, nil)
              end
            end
          end
        end
      end
    end

    # insert any HABTM join tables we discovered
    habtm_fixtures.values.each do |fixture|
      fixture.delete_existing_fixtures
      fixture.insert_fixtures
    end

    # we now return you to your regularly scheduled data loading
    insert_fixtures_without_rathole
  end
  
  class << self
    # Return rathole's consistent identifier for +key+. This will always
    # be a positive integer, and will always be the same for a given
    # key, assuming the same OS, platform, and version of Ruby.
    def identify(key)
      key.to_s.hash.abs
    end
    
    def create_fixtures_with_referential_integrity_disabled(*args)
      connection = block_given? ? yield : ::ActiveRecord::Base.connection
      
      connection.disable_referential_integrity do
        create_fixtures_without_referential_integrity_disabled(*args) { connection }
      end
    end
  end

  private

  class HabtmFixtures < ::Fixtures
    def read_fixture_files; end
  end

  def model_class
    @_rhmc ||= @class_name.is_a?(Class) ?
      @class_name : @class_name.constantize rescue nil
  end
  
  def primary_key_name
    @_rhpkn ||= model_class && model_class.primary_key
  end

  def timestamp_column_names
    @_rhtcn ||= %w(created_at created_on updated_at updated_on).select do |name|
      column_names.include?(name)
    end
  end

  def column_names
    @_rhcn ||= @connection.columns(@table_name).collect(&:name)
  end
    
  class << self
    # Normally we'd define our extensions as a module and mix it in to Fixtures.
    # Tests die if active_record/fixtures is required more than once, though,
    # so that approach wasn't working out. Instead, we directly define the
    # fixtures class and resort to the monstrosities below. I'm sorry.
    
    def method_added(method)
      case method
      when :insert_fixtures
        unless method_defined?(:insert_fixtures_without_rathole)
          alias_method_chain :insert_fixtures, :rathole
        end
      when :delete_existing_fixtures
        unless method_defined?(:delete_existing_fixtures_without_rathole)
          alias_method_chain :delete_existing_fixtures, :rathole
        end
      end
    end
    
    def singleton_method_added(method)
      if method == :create_fixtures
        class << self
          unless method_defined?(:create_fixtures_without_referential_integrity_disabled)
            alias_method_chain :create_fixtures, :referential_integrity_disabled
          end
        end
      end
    end
  end
end
