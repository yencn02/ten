namespace :nine do
  namespace :timesheets do
    desc "Creates all the timesheets each week" 
    task :create => :environment do
      TimeSheet.create_timesheets(Time.now.strftime("%m/%d/%Y"), (Time.now + (6*24*3600)).strftime("%m/%d/%Y"))
    end
  end
end
