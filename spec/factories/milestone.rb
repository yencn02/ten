Factory.define :milestone, :class => Milestone do |ms|
  ms.title "Version 1.0"
  ms.due_date Time.now + 4.month
  ms.association :project, :factory => :project
end