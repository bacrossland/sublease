# frozen_string_literal: true

require 'test_helper'

class Sublease::Test < ActiveSupport::TestCase

  context 'configure block' do
    should 'yield self' do
      Sublease.configure do |config|
        assert_equal Sublease, config
      end
    end
  end

  context 'tenant_model?' do
    should 'raise Sublease::TenantModelNotSet when tenant_model is not set' do
      Sublease.tenant_model = nil
      assert_raises Sublease::TenantModelNotSet do
        Sublease.send(:tenant_model?)
      end
    end
  end

  context 'default_tenant_domain=' do
    should 'raise Sublease::TenantNotFound when tenant is not found' do
      assert_raises Sublease::TenantNotFound do
        Sublease.default_tenant_domain = 'test'
      end
    end

    should 'set default_tenant if found' do
      Sublease.default_tenant_domain = 'example.com'
      assert_equal Tenant, Sublease.default_tenant.class
      assert_equal 'example.com', Sublease.default_tenant.domain
    end
  end

  context 'default_tenant_subdomain=' do
    should 'raise Sublease::TenantNotFound when tenant is not found' do
      assert_raises Sublease::TenantNotFound do
        Sublease.default_tenant_subdomain = 'test'
      end
    end

    should 'set default_tenant if found' do
      Sublease.default_tenant_subdomain = 'www'
      assert_equal Tenant, Sublease.default_tenant.class
      assert_equal 'www', Sublease.default_tenant.subdomain
    end
  end

  context 'default_tenant=' do
    should 'raise Sublease::TenantNotFound when tenant is nil' do
      assert_raises Sublease::TenantNotFound do
        Sublease.default_tenant = nil
      end
    end
  end

  context 'switch_on_domain=' do
    should 'return false if passed in value is not TrueClass' do
      Sublease.switch_on_domain = 1234
      assert_equal false, Sublease.switch_on_domain
      Sublease.switch_on_domain = 'true'
      assert_equal false, Sublease.switch_on_domain
    end

    should 'raise Sublease::ConfigError if switch_on_subdomain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_subdomain = true
        Sublease.switch_on_domain = true
      end
    end

    should 'raise Sublease::ConfigError if switch_on_subdomain_and_domain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_subdomain_and_domain = true
        Sublease.switch_on_domain = true
      end
    end
  end

  context 'switch_on_subdomain=' do
    should 'return false if passed in value is not TrueClass' do
      Sublease.switch_on_subdomain = 1234
      assert_equal false, Sublease.switch_on_subdomain
      Sublease.switch_on_subdomain = 'true'
      assert_equal false, Sublease.switch_on_subdomain
    end

    should 'raise Sublease::ConfigError if switch_on_domain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_domain = true
        Sublease.switch_on_subdomain = true
      end
    end

    should 'raise Sublease::ConfigError if switch_on_subdomain_and_domain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_subdomain_and_domain = true
        Sublease.switch_on_subdomain = true
      end
    end
  end

  context 'switch_on_subdomain_and_domain=' do
    should 'return false if passed in value is not TrueClass' do
      Sublease.switch_on_subdomain_and_domain = 1234
      assert_equal false, Sublease.switch_on_subdomain_and_domain
      Sublease.switch_on_subdomain_and_domain = 'true'
      assert_equal false, Sublease.switch_on_subdomain_and_domain
    end

    should 'raise Sublease::ConfigError if if switch_on_domain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_domain = true
        Sublease.switch_on_subdomain_and_domain = true
      end
    end

    should 'raise Sublease::ConfigError if if switch_on_subdomain is set' do
      assert_raises Sublease::ConfigError do
        Sublease.switch_on_subdomain = true
        Sublease.switch_on_subdomain_and_domain = true
      end
    end

  end

end
