require 'spec_helper'

describe BillableTimeController do
  before(:each) do
    @current_account = login_as_worker
  end
  def mock_billable_time(stubs={})
    @mock_billable_time ||= mock_model(BillableTime, stubs)
  end

  describe "GET index" do
    it "assigns all billable_times as @billable_times" do
      @mock_billable_times = Array.new(3) { mock_model(BillableTime) }
      @mock_billable_times=BillableTime.joins(:task).paginate(:page => 1, :per_page => 10,
      :conditions => {"tasks.worker_id" => @current_account.id}, :order => "created_at DESC")
      get :index
      assigns[:billable_times].should == @mock_billable_times
    end
  end

  describe "GET show" do
    it "assigns the requested billable_time as @billable_time" do
      BillableTime.stub(:find).with("37").and_return(mock_billable_time)
      get :show, :id => "37"
      assigns[:billable_time].should equal(mock_billable_time)
    end
  end

  describe "GET new" do
    it "assigns a new billable_time as @billable_time" do
      BillableTime.stub(:new).and_return(mock_billable_time)
      get :new
      assigns[:billable_time].should equal(mock_billable_time)
    end
  end

  describe "GET edit" do
    it "assigns the requested billable_time as @billable_time" do
      BillableTime.stub(:find).with("37").and_return(mock_billable_time)
      get :edit, :id => "37"
      assigns[:billable_time].should equal(mock_billable_time)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created billable_time as @billable_time" do
        BillableTime.stub(:new).with({'these' => 'params'}).and_return(mock_billable_time(:save => true))
        post :create, :billable_time => {:these => 'params'}
        assigns[:billable_time].should equal(mock_billable_time)
      end

      it "redirects to the created billable_time" do
        BillableTime.stub(:new).and_return(mock_billable_time(:save => true))
        post :create, :billable_time => {}
        response.should redirect_to(billable_time_url(mock_billable_time))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved billable_time as @billable_time" do
        BillableTime.stub(:new).with({'these' => 'params'}).and_return(mock_billable_time(:save => false))
        post :create, :billable_time => {:these => 'params'}
        assigns[:billable_time].should equal(mock_billable_time)
      end

      it "re-renders the 'new' template" do
        BillableTime.stub(:new).and_return(mock_billable_time(:save => false))
        post :create, :billable_time => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested billable_time" do
        BillableTime.should_receive(:find).with("37").and_return(mock_billable_time)
        mock_billable_time.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :billable_time => {:these => 'params'}
      end

      it "assigns the requested billable_time as @billable_time" do
        BillableTime.stub(:find).and_return(mock_billable_time(:update_attributes => true))
        put :update, :id => "1"
        assigns[:billable_time].should equal(mock_billable_time)
      end

      it "redirects to the billable_time" do
        BillableTime.stub(:find).and_return(mock_billable_time(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(billable_time_url(mock_billable_time))
      end
    end

    describe "with invalid params" do
      it "updates the requested billable_time" do
        BillableTime.should_receive(:find).with("37").and_return(mock_billable_time)
        mock_billable_time.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :billable_time => {:these => 'params'}
      end

      it "assigns the billable_time as @billable_time" do
        BillableTime.stub(:find).and_return(mock_billable_time(:update_attributes => false))
        put :update, :id => "1"
        assigns[:billable_time].should equal(mock_billable_time)
      end

      it "re-renders the 'edit' template" do
        BillableTime.stub(:find).and_return(mock_billable_time(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested billable_time" do
      BillableTime.should_receive(:find).with("37").and_return(mock_billable_time)
      mock_billable_time.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the billable_time list" do
      BillableTime.stub(:find).and_return(mock_billable_time(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to("/billable_time")
    end
  end

end
