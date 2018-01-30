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
  end
end
