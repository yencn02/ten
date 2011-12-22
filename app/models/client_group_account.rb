class ClientGroupAccount < ActiveRecord::Base
  belongs_to :client_group
  belongs_to :account
end
