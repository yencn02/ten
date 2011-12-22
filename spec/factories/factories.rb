Factory.define :role, :class => Role  do |wr|
  wr.name "worker" 
end

Factory.define :manager, :class =>Worker do |l|
  l.login "manager1"
  l.name "Arsene Wenger"
  l.password "123456"
  l.enabled true
  l.password_confirmation { |w| w.password }
  l.email "manager@example.com"
  l.roles { [Factory(:role, :name => Role::MANAGER)] }
  l.worker_groups {[Factory(:worker_group)]}
end

Factory.sequence :company_name do |n|
  "Company #{n}"
end

Factory.define :technical_note do |tn|
  tn.description "Technical note for task"
end

Factory.define :billable_time  do |bt|
  bt.description "Do nothing"
  bt.billed_hours "3"
end

Factory.define :late_milestone, :class => Milestone do |ms|
	ms.title "Late miletones"
	ms.due_date Time.now - 5.day
	ms.association :project, :factory => :project 	
end

Factory.define :near_milestone, :class => Milestone do |ms|
	ms.title "Near miletones"
	ms.due_date Time.now + 5.day
	ms.association :project, :factory => :project
end

Factory.define :far_milestone, :class => Milestone do |ms|
	ms.title "Far miletones"
	ms.due_date Time.now + 2.month
	ms.association :project, :factory => :project
end

Factory.define :client_request_change do |rc|
	rc.description "Customer request this change"
	rc.created_at Time.now - 5.day
	rc.association :client_request, :factory => :client_request
end



Factory.define :message_status do |msg_status|
  msg_status = "unread"
end

Factory.define :client_message_status do |msg_status|
  msg_status = "unread"
end
