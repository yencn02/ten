class BillableTimeController < ApplicationController
  # GET /billable_time
  def index
    page = params[:page] || 1
    @billable_times = BillableTime.joins(:task).paginate(:page => page, :per_page => 10,
      :conditions => {"tasks.worker_id" => current_account.id}, :order => "created_at DESC")
  end

  # GET /billable_time/1
  def show
    @billable_time = BillableTime.find(params[:id])
  end

  # GET /billable_time/new
  def new
    @billable_time = BillableTime.new
  end

  # GET /billable_time/1/edit
  def edit
    @billable_time = BillableTime.find(params[:id])
  end

  # POST /billable_time
  def create
    @billable_time = BillableTime.new(params[:billable_time])

    if @billable_time.save
      redirect_to(@billable_time, :notice => 'BillableTime was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /billable_time/1
  def update
    @billable_time = BillableTime.find(params[:id])

    if @billable_time.update_attributes(params[:billable_time])
      redirect_to(@billable_time, :notice => 'BillableTime was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /billable_time/1
  def destroy
    @billable_time = BillableTime.find(params[:id])
    @billable_time.destroy
    redirect_to("/billable_time")
  end
end
