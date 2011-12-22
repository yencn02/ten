class AttachedFilesController < ApplicationController
  before_filter :login_required

  def attach
    id_suffix = application_helper.get_id_suffix(params)
    @attached_file = AttachedFile.new(params["attachedFile#{id_suffix}"])
    @attached_file.description = params["fileNote#{id_suffix}"]
    @attached_file.client_request_id = params["rid#{id_suffix}"].to_i
    @attached_file.task_id = params["tid#{id_suffix}"]
    success = @attached_file && @attached_file.save && @attached_file.errors.empty?
    responds_to_parent do |page|
        if success          
          page.call "AttachedFile.afterSave", id_suffix
          @attached_files = AttachedFile.paginate_by_client_request(@attached_file.client_request_id, nil) unless @attached_file.client_request_id.nil?
          @attached_files = AttachedFile.paginate_by_task(@attached_file.task_id, nil) unless @attached_file.task_id.nil?
          page.replace_html "fileList#{id_suffix}", :partial => "file_list", :locals => {
            :files => @attached_files, :id_suffix => id_suffix, :readonly => false }
          page.visual_effect :highlight, "file#{@attached_file.id}", {:duration => 2}
          page.call "AttachedFile.onSuccess"
        else
          page.replace "newFileError#{id_suffix}",
            (error_messages_for :attached_file, :id => "newFileError#{id_suffix}")
          page.call "AttachedFile.onSaveFailure", id_suffix
        end      
    end
  end

  def set_file_description
    description = params[:value]
    file = AttachedFile.find(params[:id])
    unless description.nil? || description.empty?
      file.description = description
      file.save
    end
    render :text => file.description
  end

  def paginate
    page = params[:afp] # attached file page
    client_request_id = params[:rid] # client_request id
    task_id = params[:tid] # task id
    id_suffix = params[:id_suffix]    
    @attached_files = Array.new
    @current_account = current_account
    if !client_request_id.nil?
      @attached_files = AttachedFile.paginate_by_client_request(client_request_id, page)
      readonly = change_request_readonly?(@current_account)
    elsif !task_id.nil?
      @attached_files = AttachedFile.paginate_by_task(task_id, page)
      readonly = change_task_readonly?(@current_account)
    end
    render :update do |page|
      page.replace_html "fileList#{id_suffix}", :partial => "file_list", :locals => {:files => @attached_files, :id_suffix => id_suffix, :readonly => readonly}
      page.call "AttachedFile.onSuccess"
    end
  end

  def delete
    file_id = params[:id]
    file = AttachedFile.find(file_id)
    client_request_id = file.client_request_id
    task_id = file.task_id
    file.destroy
    id_suffix = params[:idSuffix]
    @attached_files = get_attached_files(client_request_id, task_id)    
    render :update do |page|
      page.visual_effect :fade, "file#{file_id}", :duration => 2
      page.delay(2) do       
        page.replace_html "fileList#{id_suffix}", :partial => "file_list",
          :locals => {:files => @attached_files, :id_suffix => id_suffix, :readonly => false}
        page.call "AttachedFile.onSuccess"
      end
    end
  end

  private

  def get_attached_files(client_request_id, task_id)
    afp = params[:afp].to_i # attached file page
    afp = 1 if afp <= 0
    attached_files = Array.new
    while attached_files.empty? && afp > 0 do
      if !client_request_id.nil?
        attached_files = AttachedFile.paginate_by_client_request(client_request_id, afp)
      elsif !task_id.nil?
        attached_files = AttachedFile.paginate_by_task(task_id, afp)
      end
      afp = afp - 1
    end
    attached_files
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

end
