require File.dirname(__FILE__) + "/../test_helper"

class UserTest < Test::Unit::TestCase
  
  context "User" do
    context "Basic" do
      setup do
        @user_basic = Tuiter::UserBasic.new
      end

      %w(id name screen_name location description profile_image_url url protected followers_count).each do |attribute|
        should_attr_accessor_for Tuiter::UserBasic, attribute
        
        should "load attribute '#{attribute}' on initialize" do
          data = eval("{'#{attribute}' => 'value'}")
          @user_basic =  Tuiter::UserBasic.new data
          assert_equal("value", @user_basic.send(attribute))
        end
      end
      
    end # context "Basic"
    
    context "Extended" do
      setup do
        @user_extended = Tuiter::UserExtended.new
      end
      
      %w(
        profile_background_color 
        profile_text_color
        profile_link_color
        profile_sidebar_fill_color
        profile_sidebar_border_color
        friends_count
        created_at
        favourites_count
        utc_offset
        time_zone
        profile_background_image_url
        profile_background_tile
        following
        notifications
        statuses_count
      ).each do |attribute|
        should_attr_accessor_for Tuiter::UserExtended, attribute
      end
    end # context "Extended"
    
    
  end # context "User"
  
  
end

