module TasksHelper
  def percent_complete(complete, total)
    return 0 if total == 0
    return 100 if complete > total
    ((complete / total) * 100).round()
  end

  def percent_pending(complete, total)
    return 0 if total == 0 || complete > total
    (((total - complete) / total) * 100).round()
  end
end
