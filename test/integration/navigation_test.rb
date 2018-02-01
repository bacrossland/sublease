require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    Sublease.tenant_model = Tenant
    host! 'staging.example.com'
  end

  context 'when switch_on_domain set' do
    should 'change to the proper tenant' do
      Sublease.switch_on_subdomain = false
      Sublease.switch_on_subdomain_and_domain = false
      Sublease.switch_on_domain = true
      get '/'
      assert_response :success
      assert_select '#current_tenant_name',Sublease.current_tenant.name
    end
  end

  context 'when switch_on_subdomain set' do
    should 'change to the proper tenant' do
      Sublease.switch_on_domain = false
      Sublease.switch_on_subdomain_and_domain = false
      Sublease.switch_on_subdomain = true
      get '/'
      assert_response :success
      assert_select '#current_tenant_name','site2'
    end
  end

  context 'when switch_on_subdomain_and_domain set' do
    should 'change to the proper tenant' do
      Sublease.switch_on_domain = false
      Sublease.switch_on_subdomain = false
      Sublease.switch_on_subdomain_and_domain = true
      get '/'
      assert_response :success
      assert_select '#current_tenant_name','site2'
    end
  end
end