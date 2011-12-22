module AdminHelper
  def company_container(companies)
    results = [["(Select Company)", nil]]
    companies.each{|x| results << [x.name, x.id]}
    results
  end

  def role_container(roles)
    results = [["(Select Role)",nil]]
    roles.each{|x| results << [x.name.titlecase, x.id]}
    results
  end

  def get_selected(container, id)
    result = nil
    container.each{|x|
      if id.to_i == x[1]
        result = x
        break
      end
    }
    result
  end
  def get_groups(companies)
    groups = {0 => [["(Select Group)", nil]]}
    companies.each{|x|
      groups[x.id] = [["(Select Group)", nil]]
      if(x.class.name == "Company")
        ar_groups = x.worker_groups
      else
        ar_groups = x.client_groups
      end
      ar_groups.each{|y|
        groups[x.id] << [y.name, y.id]
      }
    }
    return groups
  end
  def groups_to_js(companies)
    groups = get_groups(companies)
    groups.keys.each{|key|
      groups[key] = options_for_select(groups[key])
    }
    javascript_tag("var groups = #{groups.to_json}")
  end

end
