require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TechnicalNote do
  describe "Instance Methods" do
    before :each do
      @technical_note = TechnicalNote.new
    end

    it "#allows_update?" do
      task = mock_model(Task)
      account = mock_model(Account)
      @technical_note.should_receive(:task).and_return task
      expected = mock("expected")
      task.should_receive(:allows_update?).with(account).and_return expected
      @technical_note.allows_update?(account).should == expected
    end
    
  end#Instance Methods

  describe "Class Methods" do
    it "paginate_by_task" do
      task = mock_model(Task)
      page = 1
      per_page = 3
     # results = mock_model(TechnicalNote)
      results = TechnicalNote.order("created_at DESC").page(page).per(per_page).where("task_id =?", task.id)
      TechnicalNote.paginate_by_task(task.id, page, per_page).should == results
    end
  end#Class Methods

end