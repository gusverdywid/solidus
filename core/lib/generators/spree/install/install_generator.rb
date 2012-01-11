require 'rails/generators'
require 'highline/import'
require 'bundler'
require 'bundler/cli'

module Spree
  class InstallGenerator < Rails::Generators::Base
    class_option :migrate, :type => :boolean, :default => true, :banner => 'Run Spree migrations'
    class_option :seed, :type => :boolean, :default => true, :banner => 'load seed data (migrations must be run)'
    class_option :sample, :type => :boolean, :default => true, :banner => 'load sample data (migrations must be run)'
    class_option :auto_accept, :type => :boolean

    def self.source_paths
      paths = self.superclass.source_paths
      paths << File.expand_path('../templates', "../../#{__FILE__}")
      paths << File.expand_path('../templates', "../#{__FILE__}")
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    def prepare_options
      @run_migrations = options[:migrate]
      @load_seed_data = options[:seed]
      @load_sample_data = options[:sample]

      unless @run_migrations
         @load_seed_data = false
         @load_sample_data = false
      end
    end

    def add_files
      template 'config/initializers/spree.rb', 'config/initializers/spree.rb'
    end

    def config_spree_yml
      create_file "config/spree.yml" do
        settings = { 'version' => Spree.version }

        settings.to_yaml
      end
    end

    def remove_unneeded_files
      remove_file "public/index.html"
    end

    def additional_tweaks
      return unless File.exists? 'public/robots.txt'
      append_file "public/robots.txt", <<-ROBOTS
User-agent: *
Disallow: /checkouts
Disallow: /orders
Disallow: /countries
Disallow: /line_items
Disallow: /password_resets
Disallow: /states
Disallow: /user_sessions
Disallow: /users
      ROBOTS
    end

    def setup_assets
      %w{javascripts stylesheets images}.each do |path|
        empty_directory "app/assets/#{path}/store"
        empty_directory "app/assets/#{path}/admin"
      end

      template "app/assets/javascripts/store/all.js"
      template "app/assets/javascripts/admin/all.js"
      template "app/assets/stylesheets/store/all.css"
      template "app/assets/stylesheets/admin/all.css"
    end

    def create_overrides_directory
      empty_directory "app/overrides"
    end

    def configure_application
      application <<-APP

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
      APP

      append_file "config/environment.rb", "\nActiveRecord::Base.include_root_in_json = true\n"
    end

    def include_seed_data
      append_file "db/seeds.rb", <<-SEEDS
\n
Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
      SEEDS
    end

    def install_migrations
      say_status :copying, "migrations"
      silence_stream(STDOUT) do
        silence_warnings { rake 'railties:install:migrations' }
      end
    end

    def run_migrations
      if @run_migrations
        say_status :running, "migrations"
        rake('db:migrate')
      else
        say_status :skipping, "migrations (don't forget to run rake db:migrate)"
      end
    end

    def populate_seed_data
      if @load_seed_data
        say_status :loading,  "seed data"
        rake_options=[]
        rake_options << "AUTO_ACCEPT=1" if options[:auto_accept]
        rake("db:seed #{rake_options.join(' ')}")
      else
        say_status :skipping, "seed data (you can always run rake db:seed)"
      end
    end

    def load_sample_data
      if @load_sample_data
        say_status :loading, "sample data"
        rake('spree_sample:load')
      else
        say_status :skipping, "sample data (you can always run rake spree_sample:load)"
      end
    end

    def notify_about_routes
      insert_into_file File.join('config', 'routes.rb'), :after => "Application.routes.draw do\n" do
        "  # Mount Spree's routes\n  mount Spree::Core::Engine, :at => '/'\n"
      end

      unless options[:quiet]
        puts "*" * 50
        puts "We added the following line to your application's config/routes.rb file:"
        puts " "
        puts "    mount Spree::Core::Engine, :at => '/'"
      end
    end

    def complete
      unless options[:quiet]
        puts "*" * 50
        puts "Spree has been installed successfully. You're all ready to go!"
        puts " "
        puts "Enjoy!"
      end
    end

  end
end
