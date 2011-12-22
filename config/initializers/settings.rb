application_yml = "#{Rails.root}/config/settings.yml"
if File.exist? application_yml
  settings = YAML::load(File.open(application_yml))
  settings = settings[::Rails.env]  
  $activity_periodic_timer = settings["activity_periodic_timer"]
  $menu_number_of_clients = settings["menu_number_of_clients"]
  $menu_number_of_projects = settings["menu_number_of_projects"]
  $menu_number_of_workers = settings["menu_number_of_workers"]
  $duration_for_activity_calculation = settings["duration_for_activity_calculation"]
  $near_milestone = settings["near_milestone"]
else
  # Raise RuntimeError if the file does not exist
  raise RuntimeError, "Missing #{application_yml}"
end


