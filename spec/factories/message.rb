Factory.define :message do |msg|
  msg.title "Message Title"
  msg.body  {|m| "Message Body for #{m.title}"} 
  msg.created_at  Time.now - 1.day
  msg.updated_at  Time.now - 1.day  
end
