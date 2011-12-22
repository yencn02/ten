require File.dirname(__FILE__) + '/../unit_test_helper'

class MilestoneTest < Test::Unit::TestCase
  fixtures :milestones, :projects

  def test_validations
    # valid presence
    milestone = Milestone.new
    assert !milestone.valid?
    assert milestone.errors.invalid?(:name)
    assert milestone.errors.invalid?(:project_id)
    assert milestone.errors.invalid?(:due_date)
    
    # valid project_id
    milestone.name = 'name'
    milestone.project_id = -1
    assert !milestone.valid?
    assert_equal "can't be blank", milestone.errors.on(:project_id)
    
    milestone.project_id = 1.5
    assert !milestone.valid?
    assert_equal "is not a number", milestone.errors.on(:project_id)
    
    milestone.project_id = 'abc'
    assert !milestone.valid?
    assert_equal ["is not a number", "can't be blank"], milestone.errors.on(:project_id)
  end
  
  def test_create_read_update_delete
    # create
    assert_not_nil project = Project.find(1)
    milestone = Milestone.new(:name => 'name', :project_id => project.id, :due_date => '2007-12-13')
    assert milestone.save
    
    # read
    assert_not_nil milestone_read = Milestone.find(milestone.id)
    assert_equal milestone_read.name, milestone.name
    
    # change
    milestone_read.name = 'new name'
    assert milestone_read.save
    
    # delete
    assert milestone_read.destroy
  end
  
  def test_count
    # milestone.yml has 2 records
    assert_equal 2, Milestone.count
  end
  
  def test_attributes
    milestone = Milestone.new
    assert_not_nil project = Project.find(1)
    
    # write to the attributes
    milestone.name = 'name'
    milestone.project_id = project.id
    milestone.done_approved = false
    milestone.due_date = '2007-12-07'
    
    # read from the attributes
    assert_equal('name', milestone.name)
    assert_equal(false, milestone.done_approved)
    assert_equal(project.id, milestone.project_id)
    assert_equal((DateTime.parse('2007-12-07')).strftime("%b %d %Y"), milestone.due_date.strftime("%b %d %Y"))
  end
end
