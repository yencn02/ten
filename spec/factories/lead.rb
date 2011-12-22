Factory.sequence(:lead_login) {|n| "lead#{n}"}
Factory.define :lead, :class => Worker do |w|
  w.login { Factory.next :lead_login}
  w.name "Some Lead"
  w.password "123456"
  w.enabled true
  w.password_confirmation { |w| w.password }
  w.email { |wk| wk.login + "@endax.com" }
  w.roles { [Factory(:role, :name => Role::LEAD)] }
  w.worker_groups {[Factory(:worker_group)]}
end

