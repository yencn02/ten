class ChangeStateOfStaskAndClientRequest < ActiveRecord::Migration
  def self.up
    tasks = Task.all
    client_requests = ClientRequest.all
    state_of_tasks = {
      :open => "unassigned",
      :assigned => "assigned",
      :complete => "completed"
    }

    state_of_clients = {
      :unassigned => "new",
      :assigned => "started",
      :completed => "met"
    }
    tasks.each do |task|
      rc_ts = task.class.record_timestamps
      task.class.record_timestamps = false
      task.update_attributes(:status => state_of_tasks[task.status.to_sym])
      task.class.record_timestamps = rc_ts
    end

    client_requests.each do |client|
      rc_ts = client.class.record_timestamps
      client.class.record_timestamps = false
      client.update_attributes(:status => state_of_clients[client.task.status.to_sym])
      client.class.record_timestamps = rc_ts
    end    
  end

  def self.down
    tasks = Task.all
    client_requests = ClientRequest.all
    state_of_tasks = {
      :unassigned => "open",
      :assigned => "assigned",
      :completed => "complete"
    }

    state_of_clients = {
      :new => "open",
      :assigned => "assigned",
      :complete => "complete"
    }
    tasks.each do |task|
      rc_ts = task.class.record_timestamps
      task.class.record_timestamps = false
      task.update_attributes(:status => state_of_tasks[task.status.to_sym])
      task.class.record_timestamps = rc_ts
    end

    client_requests.each do |client|
      rc_ts = client.class.record_timestamps
      client.class.record_timestamps = false
      client.update_attributes(:status => state_of_clients[client.task.status.to_sym].capitalize)
      client.class.record_timestamps = rc_ts
    end    

  end
end
