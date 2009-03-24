require File.dirname(__FILE__) + "/../test_helper"

class StatusTest < Test::Unit::TestCase
  
  STATUS_BASIC_ATTRIBUTES = %w(id text source truncated in_reply_to_status_id in_reply_to_user_id favorited in_reply_to_screen_name)
  
  context "Status" do

    context "Basic" do

      should_attr_accessor_for Tuiter::StatusBasic, STATUS_BASIC_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::StatusBasic, STATUS_BASIC_ATTRIBUTES
      
      should "load attribute 'created_at' on initialize" do
        now_str = "2009-10-31 18:59:20"
        now = DateTime.parse(now_str)
        user = Tuiter::UserExtended.new("created_at" => now_str)
        assert_equal now, user.created_at
      end
      
      should "load attribute 'created_at' with current time" do
        current_time = DateTime.now
        DateTime.stubs(:now).returns(current_time)
        
        user_extended = Tuiter::UserExtended.new
        assert_equal current_time, user_extended.created_at
      end
      
    end # context "Basic"
    
    context "for Twitter" do
      should_attr_accessor_for Tuiter::Status, STATUS_BASIC_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::Status, STATUS_BASIC_ATTRIBUTES
      
      should "load attribute 'created_at' on initialize" do
        now_str = "2009-10-31 18:59:20"
        now = DateTime.parse(now_str)
        user = Tuiter::UserExtended.new("created_at" => now_str)
        assert_equal now, user.created_at
      end
      
      should "load attribute 'created_at' with current time" do
        current_time = DateTime.now
        DateTime.stubs(:now).returns(current_time)
        
        user_extended = Tuiter::UserExtended.new
        assert_equal current_time, user_extended.created_at
      end
      
      should "load user correctly" do
        user_expected = Tuiter::UserBasic.new
        Tuiter::UserBasic.expects(:new).with("user_data").returns(user_expected)
        status = Tuiter::Status.new "user" => "user_data"
        assert_equal user_expected, status.user
      end
    end # context "for Twitter"
    
  end # context "Status"
  
end

