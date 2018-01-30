# frozen_string_literal: true

require 'test_helper'
require 'generators/sublease/install/install_generator'

module Sublease
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    test 'install generator runs without errors' do
      assert_nothing_raised do
        run_generator ['sublease:install']
      end
    end

    test 'initalizer copied to config/initializers/sublease.rb' do
      path = Rails.root + 'config/initializers/sublease.rb'
      assert_file path do
        run_generator ['sublease:install']
      end
    end
  end
end
