require File.dirname(__FILE__) + '/../unit_test_helper'

class MessageTest < Test::Unit::TestCase
  fixtures :messages

  def test_validations
    # valid presence
    msg = Message.new
    assert !msg.valid?
    assert msg.errors.invalid?(:subject)
    assert msg.errors.invalid?(:body)
    assert msg.errors.invalid?(:sender_id)
    
    # valid subject's length (2..255)
    msg.subject = 's'
    assert !msg.valid?
    assert_equal "is too short (minimum is 2 characters)", msg.errors.on(:subject)
    
    msg.subject = 's' * 256
    assert !msg.valid?
    assert_equal "is too long (maximum is 255 characters)", msg.errors.on(:subject)
    
    # valid sender_id
    msg.sender_id = -1
    assert !msg.valid?
    assert_equal "is invalid", msg.errors.on(:sender_id)
    
    msg.sender_id = 1.5
    assert !msg.valid?
    assert_equal "is not a number", msg.errors.on(:sender_id)
  end
  
  def test_create_read_update_delete
    # create
    msg = Message.new(:subject => 'subject', :body => 'body', :sender_id => 1 )
    assert msg.save
    
    # read
    assert_not_nil msg_read = Message.find(msg.id)
    assert_equal msg_read.subject, msg.subject
    
    # change
    msg_read.subject = 'new subject'
    assert msg_read.save
    
    # delete
    assert msg_read.destroy
  end
  
  def test_attributes
    msg = Message.new
    
    # write to the attributes
    msg.sender_id = 1
    msg.reply_id = 0
    msg.subject = 'subject'
    msg.body = 'body'
    msg.date_sent = '2007-12-07 00:15:34'
    
    # read from the attributes
    assert_equal(1, msg.sender_id)
    assert_equal(0, msg.reply_id)
    assert_equal('subject', msg.subject)
    assert_equal('body', msg.body)
    assert_equal((DateTime.parse('2007-12-07 00:15:34')).strftime("%b %d %Y %H:%M:%S"), msg.date_sent.strftime("%b %d %Y %H:%M:%S"))
  end
end
