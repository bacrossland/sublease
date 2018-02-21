0.2.3
-----
* Exits switching method if tenant is nil.

0.2.2
-----
* Logs a tenant not found error when switching tenants instead of raising an error.

0.2.1
-----
* For speed, Sublease will not query the database for a tenant if the Sublease.current_tenant
is already set to the same subdomain and/or domain. This performance design doesn't work in Rails 
test environments where the tenant's id value changes when the record is recreated in the database. 
This speed boost is now disabled in Rails test environments forcing Sublease to find the correct 
tenant id value.

0.2.0
-----
* Add validation of uniqueness of subdomain to domain in Sublease::Tenant.


0.1.1
-----
* Removed dependency on request_store gem.

0.1.0
-----
* Initial release