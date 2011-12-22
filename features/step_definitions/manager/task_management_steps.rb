Then /^I should see the following tasks$/ do |table|
   table.hashes.each do |hash| 
      page.should have_content(hash[:title])
    end 
end
