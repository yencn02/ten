# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Reference http://quotedprintable.com/2007/11/16/seed-data-in-rails
require 'active_record/fixtures'
Dir.glob(::Rails.root.to_s + '/db/fixtures/*.yml').each do |file|  
  Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
end