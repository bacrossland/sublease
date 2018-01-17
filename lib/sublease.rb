require 'sublease/engine'
require 'sublease/errors'
require 'sublease/tenant_switcher'
require 'request_store'

module Sublease

  class << self
    attr_accessor :tenant_model, :switch_on_domain, :switch_on_subdomain, :switch_on_subdomain_and_domain

    # configure sublease with available options
    def configure
      yield self if block_given?
    end

    def current_tenant=(tenant)
      RequestStore.store[:sublease_current_tenant] = tenant
    end

    def current_tenant
      RequestStore.store[:sublease_current_tenant] || default_tenant
    end

    def current_tenant_domain=(domain)
      RequestStore.store[:sublease_current_tenant_domain] = domain
    end

    def current_tenant_domain
      RequestStore.store[:sublease_current_tenant_domain] || default_tenant_domain
    end

    def current_tenant_subdomain=(subdomain)
      RequestStore.store[:sublease_current_tenant_subdomain] = subdomain
    end

    def current_tenant_subdomain
      RequestStore.store[:sublease_current_tenant_subdomain] || default_tenant_subdomain
    end

    def default_tenant=(tenant)
      raise Sublease::TenantNotFound if tenant.nil?
      RequestStore.store[:sublease_default_tenant] = tenant
    end

    def default_tenant
      RequestStore.store[:sublease_default_tenant]
    end

    def default_tenant_domain=(domain)
      tenant_model?
      RequestStore.store[:sublease_default_tenant_domain] = domain
      if default_tenant_subdomain.nil?
        self.default_tenant = tenant_model.where(domain: domain).first
      else
        self.default_tenant = tenant_model.where(domain: domain, subdomain: default_tenant_subdomain).first
      end
    end

    def default_tenant_domain
      RequestStore.store[:sublease_default_tenant_domain]
    end

    def default_tenant_subdomain=(subdomain)
      tenant_model?
      RequestStore.store[:sublease_default_tenant_subdomain] = subdomain
      if default_tenant_domain.nil?
        self.default_tenant = tenant_model.where(subdomain: subdomain).first
      else
        self.default_tenant = tenant_model.where(domain: default_tenant_domain, subdomain: subdomain).first
      end
    end

    def default_tenant_subdomain
      RequestStore.store[:sublease_default_tenant_subdomain]
    end

    def tenant_model=(model)
      if model.class == String
        @tenant_model = model.capitalize.constantize
      else
        @tenant_model = model
      end
    end

    def switch_on_domain=(tf)
      tenant_model?
      switch_on_configuration_valid?('domain', tf)
      @switch_on_domain = tf.class == TrueClass ? true : false
    end

    def switch_on_subdomain=(tf)
      tenant_model?
      switch_on_configuration_valid?('subdomain', tf)
      @switch_on_subdomain = tf.class == TrueClass ? true : false
    end

    def switch_on_subdomain_and_domain=(tf)
      tenant_model?
      switch_on_configuration_valid?('subdomain_and_domain', tf)
      @switch_on_subdomain_and_domain = tf.class == TrueClass ? true : false
    end

    private

    def tenant_model?
      raise Sublease::TenantModelNotSet if tenant_model.nil?
      true
    end

    def switch_on_configuration_valid?(method, value)
      case method
        when 'domain'
          raise Sublease::ConfigError, 'Option switch_on_domain can not be enabled if switch_on_subdomain_and_domain is enabled.' if (switch_on_subdomain_and_domain == true && value == true)
          raise Sublease::ConfigError, 'Options switch_on_domain and switch_on_subdomain can not be enabled together. Use switch_on_subdomain_and_domain instead.' if (value == true && switch_on_subdomain == true)
        when 'subdomain'
          raise Sublease::ConfigError, 'Option switch_on_subdomain can not be enabled if switch_on_subdomain_and_domain is enabled.' if (switch_on_subdomain_and_domain == true && value == true)
          raise Sublease::ConfigError, 'Options switch_on_domain and switch_on_subdomain can not be enabled together. Use switch_on_subdomain_and_domain instead.' if (switch_on_domain == true && value == true)
        when 'subdomain_and_domain'
          raise Sublease::ConfigError, 'Option switch_on_subdomain_and_domain can not be enabled if either switch_on_domain or switch_on_subdomain is enabled.' if ((switch_on_domain == true && value == true) || (switch_on_subdomain == true && value == true))
        else
          true
      end
    end

  end
end
