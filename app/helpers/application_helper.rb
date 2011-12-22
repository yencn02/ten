# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  ID_SUFFIX_SEPARATOR = "__"

  # Set focus to a form field.
  # Add the following line before the end tag of a form
  # <%= set_focus_to :object, :method %>
  # For example
  # <%= set_focus_to :client_request, :title %>
  def set_focus_to(object, method)
    javascript_tag("$('#{object}_#{method}').focus()");
  end

  def fmt_date(date)
    date.strftime("%m/%d/%Y")  
  end
  
  def is_author(user, message)
    true if user.id == message.sender_id
  end
  
  # Build a comma-separated string from values of the specied array.
  def array_to_comma_separated_string(array)
    if array.nil?
      raise ArgumentError, "array must not be nil."
    end
    comma_separated = String.new
    array.each_index do |index|
      comma_separated << array[index]
      comma_separated << "," if (index + 1) < array.length
    end
    return comma_separated
  end

  # Parse id suffix from params
  def get_id_suffix(params)
    id_suffix = "__" #ID_SUFFIX_SEPARATOR
    params.each do |param|
      if param[0].include?(ID_SUFFIX_SEPARATOR)
        id_suffix << param[0].split(ID_SUFFIX_SEPARATOR)[1]
        break
      end
    end
    return id_suffix
  end

  def menu   
    case current_account.read_attribute(:type)      
    when Client.to_s
      render :partial => "layouts/client_menu"
    when Worker.to_s
      if @dynamic_bottom_menu_items && @bottom_menu_items
        @bottom_menu_items.concat(@dynamic_bottom_menu_items)
      end
      render :partial => "layouts/worker_menu", :locals => {
        :top_menu_items => @top_menu_items,
        :middle_menu_items => @middle_menu_items,
        :bottom_menu_items => @bottom_menu_items }
    end
  end
  
  def  roles_write_message(user)
    role_names = user.roles.collect{|role| role.name}
    return true if role_names.include?("manager") || role_names.include?("client")
  end

  def spinner(id =nil)
    image_tag('spinner.gif', :id => (id || 'spinner'), :style => "display: none; border-style: none; border: 0;")
  end

  def change_request_readonly?(current_account)
    readonly = true
    if(current_account.is_a? Client) || current_account.has_role?(Role::MANAGER)
      readonly = false
    end
    readonly
  end

  def change_task_readonly?(current_account)
    readonly = false
    if(current_account.is_a? Client)
      readonly = true
    end
    readonly
  end
    # Removes html tags from any string.
  def strip_html(str)
    if str =~ Regexp.new(/<.*?>/)
      return str.gsub!(/<.*?>/, ' ')
    else
      return str
    end
  end


  def strip_format_font(str)
    if str =~ Regexp.new(/font-size: (.*);/)
      return str.gsub!(/font-size: (.*?);/, '')
    else
      return str
    end
  end

   def linebreaks(str)
    str.gsub(/\n/) { |m| "<br/>" } if str
  end
end
