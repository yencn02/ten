require "logging"

class ActivityWorker < BackgrounDRb::MetaWorker
  set_worker_name :activity_worker

  def create(args = nil)
    add_periodic_timer($activity_periodic_timer) {
      update_activity()
    }
  end

  def update_activity
    logger.debug "Updating project activity ..."
    Project.update_activity()
    logger.debug "Finish updating project activity."
    
    logger.debug "Updating client activity ..."
    Client.update_activity()
    logger.debug "Finish updating client activity."

    logger.debug "Updating client activity ..."
    Worker.update_activity()
    logger.debug "Finish updating client activity."
  end
end

