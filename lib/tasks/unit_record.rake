desc "Convert Rails application tests to UnitRecord style"
task :convert_to_unitrecord do
  %w(unit functional).each do |test_type|
    %w(models controllers).each do |app_dir|
      full_dir = "test/#{test_type}/#{app_dir}"
      system "mkdir #{full_dir}"
      system "svn add #{full_dir}"
    end
  end
  system "svn commit -m 'Added subdirs for model and controller tests'"
  system "svn update"

  # Move old unit test files to unit/models
  Dir['test/unit/*.rb'].each do |unit_file|
    old_contents = File.read(unit_file)
    new_filename = "test/unit/models/#{File.basename(unit_file)}"
    File.open(new_filename, "w") do |f|
      f.write old_contents.gsub("require File.dirname(__FILE__) + '/../test_helper'", "require File.dirname(__FILE__) + '/../unit_test_helper'")
    end
    system "svn delete #{unit_file}"
    system "svn add #{new_filename}"
  end
  # Move functional files to functional/controllers
  Dir['test/functional/*.rb'].each do |functional_file|
    old_contents = File.read(functional_file)
    new_filename = "test/functional/controllers/#{File.basename(functional_file)}"
    File.open(new_filename, "w") do |f|
      f.write old_contents.gsub("require File.dirname(__FILE__) + '/../test_helper'", "require File.dirname(__FILE__) + '/../functional_test_helper'")
    end
    system "svn delete #{functional_file}"
    system "svn add #{new_filename}"
  end

  unit_test_helper_file = "test/unit/unit_test_helper.rb"
  File.open(unit_test_helper_file, 'w') do |f|
    f.write <<EOF
require File.dirname(__FILE__) + "/../test_helper"
require "unit_record"
ActiveRecord::Base.disconnect!
EOF
  end
  system "svn add #{unit_test_helper_file}"

  functional_test_helper_file = "test/functional/functional_test_helper.rb"
  File.open(functional_test_helper_file, 'w') do |f|
    f.write %(require File.dirname(__FILE__) + "/../test_helper")
  end
  system "svn add #{functional_test_helper_file}"

  system "svn commit -m 'Updated filepaths and contents for UnitRecord'"
end