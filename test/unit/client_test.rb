require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase

  context "A valid Tuiter client" do

    setup do
      @username = "username"
      @password = "password"
      @client = Tuiter::Client.new(:username => @username, :password => @password)
    end

    context "posting data" do
      setup do
        @update_message = "I'm fine"
        FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json", :string => @update_message, :status => "200")
      end

      should "allow the user to post an update to Twitter" do
        # basic authentication and form data
        Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
        Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)

        @response = @client.update(@update_message)
 
        assert_instance_of Net::HTTPOK, @response
      end

    end
    
  end
end