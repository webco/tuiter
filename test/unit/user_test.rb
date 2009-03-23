require File.dirname(__FILE__) + "/../test_helper"

class UserTest < Test::Unit::TestCase
  
  USER_BASICS_ATTRIBUTES = %w(id name screen_name location description profile_image_url url protected followers_count)
  USER_EXTEDNED_ATTRIBUTES = USER_BASICS_ATTRIBUTES + %w(profile_background_color profile_text_color profile_link_color profile_sidebar_fill_color profile_sidebar_border_color utc_offset time_zone profile_background_image_url profile_background_tile following notifications)
  USER_EXTEDNED_ATTRIBUTES_INTEGER = %w(friends_count statuses_count favourites_count)
  USER_EXTEDNED_ATTRIBUTES_TIME = %w(created_at)
  USER_TWITTER_ATTRIBUTES = USER_BASICS_ATTRIBUTES + %w(status)

  context "User" do
    context "Basic" do
      should_attr_accessor_for Tuiter::UserBasic, USER_BASICS_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::UserBasic, USER_BASICS_ATTRIBUTES
    end # context "Basic"
    
    context "Extended" do
      setup do
        @now_str = "2009-10-31 18:59:20"
        @now = DateTime.parse(@now_str)
      end
      should_attr_accessor_for Tuiter::UserExtended, USER_EXTEDNED_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::UserExtended, USER_EXTEDNED_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::UserExtended, USER_EXTEDNED_ATTRIBUTES_INTEGER, 10
      
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
    end # context "Extended"
    
    context "Twitter" do
      should_attr_accessor_for Tuiter::User, USER_TWITTER_ATTRIBUTES
      should_load_attribute_on_initialize Tuiter::User, USER_BASICS_ATTRIBUTES
      
      should "load attribute 'status' correctly" do
        status_expected = Tuiter::StatusBasic.new
        Tuiter::StatusBasic.expects(:new).with("teste").returns(status_expected)
        user = Tuiter::User.new "status" => "teste"
        assert_equal status_expected, user.status
      end
      
    end # context "Twitter"
    
    
    
  end # context "User"
  
  
end

