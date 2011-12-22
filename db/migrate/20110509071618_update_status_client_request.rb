class UpdateStatusClientRequest < ActiveRecord::Migration
  def self.up
    client_requests = ClientRequest.all
    client_requests.each do |item|      
      item.update_attributes(:status => item.task.status.capitalize)
    end
  end

  def self.down
    client_requests = ClientRequest.all
    client_requests.each do |item|
      item.update_attributes(:status => "new")
    end
  end
end
