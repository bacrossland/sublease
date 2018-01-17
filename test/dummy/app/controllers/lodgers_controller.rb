class LodgersController < ApplicationController
  def index
    @current_tenant_name = Sublease.current_tenant.name
    @default_tenant_name = Sublease.default_tenant.name unless Sublease.default_tenant.nil?
    @lodgers = Sublease.current_tenant.lodgers
  end
end
