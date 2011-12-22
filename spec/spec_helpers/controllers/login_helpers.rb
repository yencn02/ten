def login_as_worker
  worker = Worker.new()
  worker.roles = [Role.new(:name => Role::WORKER)]
  controller.stub!(:current_account).and_return(worker)
  controller.stub!(:logged_in?).and_return(true)
  return worker
end

def login_as_lead
  worker = Worker.new()
  worker.roles = [Role.new(:name => Role::LEAD)]
  controller.stub!(:current_account).and_return(worker)
  controller.stub!(:logged_in?).and_return(true)
  return worker
end

def login_as_client
  client = Client.new 
  client.id = 1
  controller.stub!(:current_account).and_return(client)
  controller.stub!(:logged_in?).and_return(true)
  return client
end
def login_as_admin
  worker = Worker.new()
  worker.roles = [Role.new(:name => Role::ADMIN)]
  controller.stub!(:current_account).and_return(worker)
  controller.stub!(:logged_in?).and_return(true)
  return worker
end
def login_as_manager
  worker = Worker.new()
  worker.roles = [Role.new(:name => Role::MANAGER)]
  controller.stub!(:current_account).and_return(worker)
  controller.stub!(:logged_in?).and_return(true)
  return worker
end