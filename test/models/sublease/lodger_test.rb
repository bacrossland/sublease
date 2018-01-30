require 'test_helper'

module Sublease
  class LodgerTest < ActiveSupport::TestCase
    setup do
      @lodger = ::Lodger.first
    end

    context 'allow_sublease_change' do
      should 'return false when not set' do
        assert_equal false, @lodger.allow_sublease_change
      end

      should 'return false when set to anything not a true or false' do
        @lodger.allow_sublease_change = 1
        assert_equal false, @lodger.allow_sublease_change

        @lodger.allow_sublease_change = 'true'
        assert_equal false, @lodger.allow_sublease_change
      end

      should 'return true when set to true' do
        @lodger.allow_sublease_change = true
        assert_equal true, @lodger.allow_sublease_change
      end
    end


    context 'changing the tenant' do
      should 'fail without allow_sublease_change being set to true' do
        @lodger.tenant_id = 2
        assert_equal false, @lodger.valid?
        assert_equal true, @lodger.errors.messages.has_key?(:tenant_id)
      end

      should 'fail with allow_sublease_change being set to true but value is invalid' do
        @lodger.tenant_id = 1234
        @lodger.allow_sublease_change = true
        assert_equal false, @lodger.valid?
        assert_equal true, @lodger.errors.messages.has_key?(:tenant_id)
      end

      should 'succeed with allow_sublease_change being set to true' do
        tenant_id = ::Tenant.where.not(id: @lodger.tenant_id).pluck(:id).first
        @lodger.tenant_id = tenant_id
        @lodger.allow_sublease_change = true
        assert_equal true, @lodger.valid?
      end
    end

    context 'overridden Class method delete' do
      should 'call destroy' do
        Lodger.stub :destroy, true do
          assert(Lodger.delete(1))
        end
      end
    end

    context 'overridden Instance method delete' do
      should 'call destroy' do
        @lodger.stub :destroy, true do
          assert(@lodger.delete)
        end
      end
    end
  end
end
