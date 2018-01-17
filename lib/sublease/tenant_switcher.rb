module Sublease
  module TenantSwitcher
    extend ActiveSupport::Concern

    included do
      before_filter :sublease_switch_on_domain, if: :sublease_switch_on_domain?
      before_filter :sublease_switch_on_subdomain, if: :sublease_switch_on_subdomain?
      before_filter :sublease_switch_on_subdomain_and_domain, if: :sublease_switch_on_subdomain_and_domain?
    end

    private

    def sublease_error_tenant_not_found(message)
      raise Sublease::TenantNotFound, message
    end

    def sublease_model
      model = Sublease.tenant_model
      if model.class == String
        model = model.capitalize.constantize
      end
      return model
    end

    def sublease_set_current_tenant(tenant)
      Sublease.current_tenant = tenant
      Sublease.current_tenant_domain = tenant.domain
      Sublease.current_tenant_subdomain = tenant.subdomain
    end

    def sublease_switch_on_domain
      return if Sublease.current_tenant_domain == request.domain
      model = sublease_model
      tenant = model.where(domain: request.domain).first
      if tenant.nil?
        sublease_error_tenant_not_found(I18n.t('sublease.errors.domain_not_found', domain: request.domain))
      end
      sublease_set_current_tenant(tenant)
    end

    def sublease_switch_on_domain?
      (Sublease.switch_on_domain == true)
    end

    def sublease_switch_on_subdomain
      return if Sublease.current_tenant_subdomain == request.subdomain
      model = sublease_model
      tenant = model.where(subdomain: request.subdomain).first
      if tenant.nil?
        sublease_error_tenant_not_found(I18n.t('sublease.errors.subdomain_not_found', subdomain: request.subdomain))
      end
      sublease_set_current_tenant(tenant)
    end

    def sublease_switch_on_subdomain?
      (Sublease.switch_on_subdomain == true)
    end

    def sublease_switch_on_subdomain_and_domain
      return if ((Sublease.current_tenant_subdomain == request.subdomain) && (Sublease.current_tenant_domain == request.domain))
      model = sublease_model
      tenant = model.where(domain: request.domain, subdomain: request.subdomain).first
      if tenant.nil?
        sublease_error_tenant_not_found(I18n.t('sublease.errors.subdomain_and_domain_not_found', subdomain: request.subdomain, domain: request.domain))
      end
      sublease_set_current_tenant(tenant)
    end

    def sublease_switch_on_subdomain_and_domain?
      (Sublease.switch_on_subdomain_and_domain == true)
    end
  end
end