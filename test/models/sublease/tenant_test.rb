require 'test_helper'

module Sublease
  class TenantTest < ActiveSupport::TestCase
    setup do
      @tenant = ::Tenant.first
    end

    context 'overridden Class method delete' do
      should 'call destroy' do
        Tenant.stub :destroy, true do
          assert(Tenant.delete(1))
        end
      end
    end

    context 'overridden Instance method delete' do
      should 'call destroy' do
        @tenant.stub :destroy, true do
          assert(@tenant.delete)
        end
      end
    end

    context 'after save' do
      should 'reload Sublease.current_tenant' do
        Sublease.current_tenant = @tenant
        @tenant.name = 'Test test'
        @tenant.save
        assert_equal 'Test test', Sublease.current_tenant.name
      end
      should 'reload Sublease.default_tenant' do
        Sublease.default_tenant = @tenant
        @tenant.name = 'Test test'
        @tenant.save
        assert_equal 'Test test', Sublease.default_tenant.name
      end
    end
  end
end
