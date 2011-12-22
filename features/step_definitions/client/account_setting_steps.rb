When /^(?:|I )follow my account$/ do
  click_link(@client.name)
end
And /^(?:|I )should see my account details$/ do
  if page.respond_to? :should
    page.should have_content(@client.name)
    page.should have_content(@client.login)
    page.should have_content(@client.email)
  else
    assert page.has_content?("details infomation")
  end

end