# frozen_string_literal: true

module Sublease
  class Lodger < ActiveRecord::Base
    self.abstract_class = true

    class << self

      # Overrides standard ActiveRecord::Relation delete to call destroy instead ensuring all callbacks are fired.
      def delete(id_or_array)
        destroy(id_or_array)
      end

      # Establishes an ActiveRecord Association. Takes the same options as
      # ActiveRecord::Associations::ClassMethods belong_to except it will ignore the dependent option in order to prevent
      # destroying tenant on destruction of lodger. Validates presence of tenant id.
      def belongs_to_sublease(tenant, options = {})
        belongs_to tenant.to_sym, options.delete(:dependent)

        before_validation -> {valid_sublease_change(tenant)}, on: :update

        validates "#{tenant}_id".to_sym, presence: true
        validate -> {valid_sublease_tenant(tenant)}

      end
    end

    # Allow the sublease to be changed if true. Returns true or false.
    def allow_sublease_change
      @allow_sublease_change ||= false
    end

    # Allows the sublease to be changed. Set using true or false.
    def allow_sublease_change=(tf)
      @allow_sublease_change = tf.class == TrueClass ? true : false
    end

    # Checks if the sublease can be changed. Returns true or false.
    def allow_sublease_change?
      allow_sublease_change
    end

    # Overrides standard object delete to call destroy instead ensuring all callbacks are fired.
    def delete
      destroy
    end

    private

    def add_sublease_error(tenant, type, msg = nil)
      options = {}
      unless msg.nil?
        options = {message: msg}
      end
      errors.add tenant, type, options
    end

    def valid_sublease_change(tenant)
      if (send("#{tenant}_id_changed?".to_sym) && (!allow_sublease_change?))
        add_sublease_error("#{tenant}_id".to_sym, :changed, I18n.t('sublease.errors.changed'))
      end
    end

    def valid_sublease_tenant(tenant)
      unless tenant.to_s.capitalize.constantize.where(id: self.send("#{tenant}_id".to_sym)).exists?
        add_sublease_error("#{tenant}_id".to_sym, :invalid)
      end
    end

  end
end
