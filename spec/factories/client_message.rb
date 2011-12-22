Factory.define :client_message do |msg|
	msg.title "Client Message Title"
	msg.body  {|m| "Message Body for #{m.title}"} 
	msg.created_at  Time.now - 1.day
	msg.updated_at  Time.now - 1.day
  msg.association :client_request, :factory => :client_request
end