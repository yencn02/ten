Factory.sequence(:request_title) {|n| "Client Request #{n}"}
Factory.define :client_request do |r|  
  r.title {Factory.next :request_title}
  r.description "Here is the description for this client_request"
  r.created_at Time.now
  r.priority 2
  r.status "new"
  r.association :milestone, :factory => :milestone 
end