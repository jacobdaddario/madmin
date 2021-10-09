module Madmin
  class Engine < ::Rails::Engine
    config.before_configuration do |app|
      app.config.autoload_paths << File.expand_path("app/madmin/resources", Rails.root)
      app.config.autoload_paths << File.expand_path("app/madmin/fields", Rails.root)
    end

    config.to_prepare do
      Madmin.reset_resources!
    end

    # Isolating the helpers from the main app
    config.after_initialize do |app|
      railtie = self
      Madmin.singleton_class.instance_eval do
        define_method(:railtie_helpers_paths) { railtie.helpers_paths }
      end

      app.config.helpers_paths.delete(*paths["app/helpers"].existent)
    end
  end
end
