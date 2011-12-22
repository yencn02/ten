class AccountsController < ApplicationController
  before_filter :login_required
  layout "application"
  def paginate_workers
    @current_page = params[:page]
    selected_worker = params[:selected_worker]
    @workers = Worker.paginate_by_activity(current_account, @current_page)
    render :partial => "accounts/navbar_worker", :locals => {
      :workers => @workers, :selected_worker => selected_worker, :page => @current_page}
  end
  def show
    @worker = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @worker }
    end
  end
  def edit
    @worker = Account.find(params[:id])
  end
  def update
    @worker = Account.find(params[:id])
    account = params[:worker]?params[:worker]:params[:client]
    respond_to do |format|
      if @worker.update_attributes(account)
        format.html { redirect_to(:controller=>"accounts",:action=>"show",:id => @worker, :notice => 'successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @worker.errors, :status => :unprocessable_entity }
      end
    end
  end
end
