require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase
  
  def self.fake_web_post_on_update(message = "Ok", http_response_status = 200)
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json", :string => message, :status => http_response_status.to_s)
  end

  context "A valid Tuiter client" do

    setup do
      @username = "username"
      @password = "password"
      @client = Tuiter::Client.new(:username => @username, :password => @password)
    end

    context "posting data" do
      setup do
      end

      context "successfully" do

        setup do
          @update_message = "I'm fine"
          FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json", 
                               :string => @update_message, 
                               :status => "200")
        end

        should "allow the user to post an update to Twitter" do
          # basic authentication and form data
          Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
          Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)

          @response = @client.statuses_update(@update_message)

          assert_instance_of Net::HTTPOK, @response
        end
        
      end # context "successfully"
      
      context "some error on request" do
        setup do
          @update_message = "I'm fine"
          FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json", 
                               :string => "503 Service unavailable", 
                               :status => ["503", "Service unavailable"])
        end
        
        should "raise for http response status on 503" do
          Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
          Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)
          assert_raises Net::HTTPFatalError do
            @response = @client.statuses_update(@update_message)
          end
          # assert_instance_of Net::HTTPServiceUnavailable, @response
        end
        
      end # context "some error on request"
      
      
    end # context "posting data"
    
    
  end # context "A valid Tuiter client"
end