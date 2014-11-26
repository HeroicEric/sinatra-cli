require "thor"

module Sinatra
  module CLI
    class Generator < Thor::Group
      include Thor::Actions

      argument :app_name

      def self.source_root
        File.join(File.dirname(__FILE__), "../../../", "templates")
      end

      def create_models_dir
        keep_file "#{app_name}/app/models"
      end

      def create_views_dir
        template "app/views/index.erb", "#{app_name}/views/index.erb"
        template "app/views/layout.erb", "#{app_name}/views/layout.erb"
      end

      def create_database_config
        template "config/database.yml.erb", "#{app_name}/config/database.yml"
      end

      def create_seeds_file
        copy_file "db/seeds.rb", "#{app_name}/db/seeds.rb"
      end

      def create_assets
        create_file "#{app_name}/public/javascripts/app.js"
        create_file "#{app_name}/public/stylesheets/app.css"
        keep_file "#{app_name}/public/images/"
      end

      def create_gitignore
        copy_file ".gitignore", "#{app_name}/.gitignore"
      end

      def create_app_file
        copy_file "app.rb", "#{app_name}/app.rb"
      end

      def create_gemfile
        copy_file "Gemfile", "#{app_name}/Gemfile"
      end

      def create_rakefile
        copy_file "Rakefile", "#{app_name}/Rakefile"
      end

      def create_readme
        template "README.md.erb", "#{app_name}/README.md"
      end

      def setup_rspec
        insert_into_file(
          "#{app_name}/Gemfile",
          "gem 'rspec'",
          after: "group :test, :development do"
        )

        copy_file ".rspec", "#{app_name}/.rspec"
        copy_file "spec/spec_helper.rb", "#{app_name}/spec/spec_helper.rb"
      end

      def setup_capybara
        insert_into_file(
          "#{app_name}/Gemfile",
          "gem 'capybara'",
          after: "group :test, :development do"
        )

        insert_into_file(
          "#{app_name}/spec/spec_helper.rb",
          "require 'capybara/rspec'",
          after: "require 'rspec'"
        )

        append_to_file "#{app_name}/spec/spec_helper.rb", "\n\nCapybara.app = Sinatra::Application"
      end

      def bundle_install
        system "cd #{app_name} && bundle install && cd ../"
      end

      protected

      def keep_file(destination)
        create_file "#{destination}/.keep"
      end
    end
  end
end
