module Sublease
  class ConfigError < StandardError
  end

  class TenantModelNotSet < StandardError
  end

  class TenantNotFound < StandardError
  end
end