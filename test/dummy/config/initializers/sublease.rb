#
# Sublease Configuration
#
Sublease.configure do |config|

  # The tenant model Sublease will search when switching by subdomain or domain.
  config.tenant_model = Tenant

  # Enable switching of tenant on domain.
  # config.switch_on_domain = true

  # Enable switching of tenant on subdomain.

  #config.switch_on_subdomain = true

  # Enable switching of tenant on combined subdmain and domain.
  config.switch_on_subdomain_and_domain = true

  # The default tenant subdomain
  #config.default_tenant_subdomain = 'www'

  # The default tenant domain
  #config.default_tenant_domain = 'example.com'
end
