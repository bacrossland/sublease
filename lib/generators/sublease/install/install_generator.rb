module Sublease
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template "sublease.rb", File.join("config", "initializers", "sublease.rb")
    end
  end
end
