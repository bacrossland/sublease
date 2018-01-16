module Sublease
  class Lodger < ActiveRecord::Base
    self.abstract_class = true
    attr_accessor :allow_sublease_change

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

        before_validation -> {add_sublease_error("#{tenant}_id".to_sym)}, on: :update, if: "#{tenant}_id_changed?".to_sym

        validates "#{tenant}_id".to_sym, presence: true

      end
    end

    # Allows the sublease to be changed. Set using true or false.
    def allow_sublease_change=(tf)
      @allow_sublease_change = tf.class == TrueClass ? true : false
    end

    # Checks if the sublease can be changed. Returns true or false.
    def allow_sublease_change?
      allow_sublease_change.nil? ? false : allow_sublease_change
    end

    # Overrides standard object delete to call destroy instead ensuring all callbacks are fired.
    def delete
      destroy
    end

    private

    def add_sublease_error(tenant)
      unless allow_sublease_change?
        msg = I18n.t('sublease.errors.changed')
        if Rails::VERSION::MAJOR > 4
          errors.add tenant, :changed, message: msg
        else
          errors.add tenant, message: msg
        end
      end
    end

  end
end
