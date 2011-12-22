Factory.sequence(:worker_login) {|n| "worker#{n}"}
Factory.define :worker do |w|  
  w.login { Factory.next :worker_login}
  w.name "Roger Federer"
  w.password "123456"
  w.enabled true
  w.password_confirmation { |w| w.password }
  w.email { |wk| wk.login + "@endax.com" }  
  w.roles { [Factory(:role)] }
  w.worker_groups {[Factory(:worker_group)]}
end
