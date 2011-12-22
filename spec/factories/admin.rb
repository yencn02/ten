Factory.define :admin, :class => Worker do |u|
  u.login "admin"
  u.name "Administrator"
  u.password "123456"
  u.password_confirmation { |w| w.password }
  u.email "admin@endax.com"
  u.enabled true
  u.roles { [Factory(:role, :name => Role::ADMIN)] }
  u.worker_groups {[Factory(:worker_group)]}
end

