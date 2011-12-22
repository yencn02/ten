Factory.sequence(:task_name) {|n| "Task #{n}"}

Factory.define :task do |t|  
  t.title { Factory.next :task_name }
  t.estimated_hours 10
  t.start_date Time.now - 1.day
  t.due_date Time.now + 3.day
  t.status "assigned"
  #t.association  :project, :factory => :projectX
end
