# frozen_string_literal: true

module Sublease
  class Tenant < ActiveRecord::Base
    self.abstract_class = true

    validates :subdomain, uniqueness: { scope: :domain }
    after_save :reload_current_and_default_tenant

    class << self

      # Overrides standard ActiveRecord::Relation delete to call destroy instead ensuring all callbacks are fired.
      def delete(id_or_array)
        destroy(id_or_array)
      end

      # Establishes an ActiveRecord Association with a forced destroy dependency. Takes the same options as
      # ActiveRecord::Associations::ClassMethods has_many except it will override the dependent option with
      # a dependent: :destroy in order to ensure the destruction of logders when the tenant is destroyed.
      def has_many_subleases(lodger, options = {})
        has_many lodger.to_sym, options.delete(:dependent), dependent: :destroy
      end

    end

    # Overrides standard object delete to call destroy instead ensuring all callbacks are fired.
    def delete
      destroy
    end

    private

    def reload_current_and_default_tenant
      unless Sublease.default_tenant.nil?
        Sublease.default_tenant.reload
      end

      unless Sublease.current_tenant.nil?
        Sublease.current_tenant.reload
      end
    end

  end
end
