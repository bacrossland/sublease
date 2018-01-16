class Tenant < Sublease::Tenant
  has_many_subleases(:lodgers)
end
