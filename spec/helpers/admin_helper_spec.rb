require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "AdminHeler" do
  include AdminHelper

  it "#company_container" do
    companies = [mock_model(Company, {:name => "Company name "})]
    
    results = [["(Select Company)",nil]]
    companies.each{|x| results << [x.name, x.id]}
    
    company_container(companies).should == results
  end

  it "#role_container" do
    roles = [mock_model(Role, {:name => "Role name "})]

    results = [["(Select Role)",nil]]
    roles.each{|x| results << [x.name.titlecase, x.id]}

    role_container(roles).should == results
  end
  
  describe "#get_selected" do
    it "#should return existed object" do
      company1 = mock_model(Company, {:name => "Company name 1", :id => 1})
      company2 = mock_model(Company, {:name => "Company name 2", :id => 2})
      companies = [company1, company2]
      container = company_container(companies)

      #Selected: id=1
      selected_id = company1.id
      selected_obj = nil
      container.each{|x|
        if selected_id.to_i == x[1]
          selected_obj = x
          break
        end
      }

      get_selected(container, selected_id).should == selected_obj
    end
    it "#should return nil" do
      company1 = mock_model(Company, {:name => "Company name 1", :id => 1})
      company2 = mock_model(Company, {:name => "Company name 2", :id => 2})
      companies = [company1, company2]
      container = company_container(companies)

      #Selected: id=1
      selected_id = 3
      selected_obj = nil
      container.each{|x|
        if selected_id.to_i == x[1]
          selected_obj = x
          break
        end
      }

      get_selected(container, selected_id).should be_nil
    end
  end
  describe "#get_groups" do
    it "#get groups for worker" do
      groups = {0 => [["(Select Group)", nil]]}
      worker_group = mock_model(WorkerGroup, {:name => "Worker group"})
      companies = [mock_model(Company, {:name => "Company name ", :worker_groups => [worker_group]})]
      companies.each{|x|
        groups[x.id] = [["(Select Group)", nil]]
        x.worker_groups.each{|y|
          groups[x.id] << [y.name, y.id]
        }
      }
      get_groups(companies).should == groups
    end
    
    it "#get groups for client" do
      groups = {0 => [["(Select Group)", nil]]}
      client_group = mock_model(ClientGroup, {:name => "client group"})
      companies = [mock_model(ClientCompany, {:name => "Company name ", :client_groups => [client_group]})]
      companies.each{|x|
        groups[x.id] = [["(Select Group)", nil]]
        x.client_groups.each{|y|
          groups[x.id] << [y.name, y.id]
        }
      }
      get_groups(companies).should == groups
    end
  end

  it "#groups_to_js" do
    worker_group = mock_model(WorkerGroup, {:name => "Worker group"})
    companies = [mock_model(Company, {:name => "Company name ", :worker_groups => [worker_group]})]
    groups = get_groups(companies)
    groups.keys.each{|key|
      groups[key] = options_for_select(groups[key])
    }
    groups_to_js(companies).should == javascript_tag("var groups = #{groups.to_json}")
  end
end