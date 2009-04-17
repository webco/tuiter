require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase
  
  def fake_web_on_post(url, options = {:string => "OK", :status => "200"})
    FakeWeb.register_uri(:post, url, options)
  end
  
  context "A valid Tuiter client without proxy" do

    setup do
      @username = "username"
      @password = "password"
      @client = Tuiter::Client.new(:username => @username, :password => @password)
    end

    context "on POST to statuses/update" do
      setup do
        @update_message = "I'm fine"
      end

      context "with successfully response" do
        setup do
          fake_web_on_post("http://twitter.com/statuses/update.json", :string => @update_message, :status => "200")
        end

        should "allow the user to post an update to Twitter" do
          # basic authentication and form data
          Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
          Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)

          assert_nothing_raised do
            @response = @client.update(@update_message)
          end
          assert_instance_of Net::HTTPOK, @response
        end
        
        should "allow the user to post a reply to Twitter" do
          # basic authentication and form data
          Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
          Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => "1234567890")
          
          assert_nothing_raised do
            @response = @client.update(@update_message, "1234567890")
          end
          assert_instance_of Net::HTTPOK, @response
        end
        
      end # context "with successfully response"
      
      context "with error response" do
        setup do
          response_status = ["503", "Service unavailable"]
          fake_web_on_post("http://twitter.com/statuses/update.json", :string => response_status.join(" "), :status => response_status)
        end
        
        should "raise for http response status on 503" do
          Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
          Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)
          
          assert_raises Net::HTTPFatalError do
            @client.update(@update_message)
          end
        end
        
      end # context "with error response"
      
      
    end # context "on POST to statuses/update"
    
    context "on POST to direct_messages/new" do
      setup do
        fake_web_on_post("http://twitter.com/direct_messages/new.json")
        @anoter_user = "1234567890"
        @text = "Hello World!"
      end
      
      should "allow the user to post a direct message to another Twitter's user" do
        Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
        Net::HTTP::Post.any_instance.expects(:set_form_data).with('user'=>@another_user, 'text'=>@text )
        
        assert_nothing_raised do
          @response = @client.direct_new(@another_user, @text)
        end
        assert_instance_of(Net::HTTPOK, @response)
      end
    end # context "on POST to direct_messages/new"
    
    
  end # context "A valid Tuiter client"
end