require File.dirname(__FILE__) + '/../unit_test_helper'

class ClientRequestTest < Test::Unit::TestCase
  def test_total_billed_hours
    client_request_id = 1

    task_1 = Task.new
    task_1.client_request_id = client_request_id
    task_1.billed_hours = 4

    task_2 = Task.new
    task_2.client_request_id = client_request_id
    task_2.billed_hours = 8

    Task.stubs(:find_all_by_client_request_id).with(client_request_id).returns([task_1, task_2])

    client_request = ClientRequest.new
    client_request.id = 1
    assert_equal 12, client_request.total_billed_hours
  end

  def test_total_estimated_hours
    client_request_id = 1

    task_1 = Task.new
    task_1.client_request_id = client_request_id
    task_1.estimated_hours = 8

    task_2 = Task.new
    task_2.client_request_id = client_request_id
    task_2.estimated_hours = 8

    Task.stubs(:find_all_by_client_request_id).with(client_request_id).returns([task_1, task_2])

    client_request = ClientRequest.new
    client_request.id = client_request_id
    assert_equal 16, client_request.total_estimated_hours
  end

  def test_has_right_with_admin_account
    # Create a worker account with "admin" role.
    role = Role.new(:id => 198763, :name => Role::ADMIN)
    admin = Worker.new
    admin.roles << role

    Worker.stubs(:find).returns(admin)
    client_request = ClientRequest.new
    assert_equal true, client_request.has_right?(admin.id)
  end

  def test_has_right_with_valid_worker_account
    # Create a worker account with "worker" role.
    role = Role.new(:id => 764837, :name => Role::WORKER)
    worker_1 = Worker.new
    worker_1.id = 879843
    worker_1.roles << role
    Worker.stubs(:find).with(worker_1.id).returns(worker_1)

    worker_2 = Worker.new
    worker_2.id = 879843
    worker_2.roles << role
    Worker.stubs(:find).with(worker_2.id).returns(worker_2)

    client_request = ClientRequest.new
    client_request.stubs(:worker_list).returns([worker_1, worker_2])
    assert_equal true, client_request.has_right?(worker_1.id)
  end

  def test_has_right_with_invalid_worker_account
    role = Role.new(:id => 764837, :name => Role::WORKER)
    worker_1 = Worker.new
    worker_1.id = 879843
    worker_1.roles << role
    Worker.stubs(:find).with(worker_1.id).returns(worker_1)

    worker_2 = Worker.new
    worker_2.id = 879843
    worker_2.roles << role
    Worker.stubs(:find).with(worker_2.id).returns(worker_2)

    invalid_worker = Worker.new
    invalid_worker.id = 209843
    invalid_worker.roles << role
    Worker.stubs(:find).with(invalid_worker.id).returns(invalid_worker)

    client_request = ClientRequest.new
    client_request.stubs(:worker_list).returns([worker_1, worker_2])
    assert_equal false, client_request.has_right?(invalid_worker.id)
  end

  def test_has_right_with_not_existed_worker_account
    role = Role.new(:id => 764837, :name => Role::WORKER)
    worker_1 = Worker.new
    worker_1.id = 879843
    worker_1.roles << role
    Worker.stubs(:find).with(worker_1.id).returns(worker_1)

    worker_2 = Worker.new
    worker_2.id = 879843
    worker_2.roles << role
    Worker.stubs(:find).with(worker_2.id).returns(worker_2)

    not_existed_worker_id = 584309
    Worker.stubs(:find).with(not_existed_worker_id).raises(ActiveRecord::RecordNotFound, "Record not found")

    client_request = ClientRequest.new
    client_request.stubs(:worker_list).returns([worker_1, worker_2])
    assert_raise ActiveRecord::RecordNotFound do
      client_request.has_right?(not_existed_worker_id)
    end
  end

  def test_has_right_with_empty_worker_list
    role = Role.new(:id => 764837, :name => Role::WORKER)
    worker = Worker.new
    worker.id = 209843
    worker.roles << role
    Worker.stubs(:find).with(worker.id).returns(worker)

    client_request = ClientRequest.new
    client_request.stubs(:worker_list).returns([])
    assert_equal false, client_request.has_right?(worker.id)
  end

  def test_has_right_with_nil_worker_list
    role = Role.new(:id => 764837, :name => Role::WORKER)
    worker = Worker.new
    worker.id = 209843
    worker.roles << role
    Worker.stubs(:find).with(worker.id).returns(worker)

    client_request = ClientRequest.new
    client_request.stubs(:worker_list).returns(nil)
    assert_equal false, client_request.has_right?(worker.id)
  end
end