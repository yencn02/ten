class WorkerGroupAccount < ActiveRecord::Base
  belongs_to :worker_group
  belongs_to :account
end
