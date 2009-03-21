require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase

  context "A valid Tuiter client" do

    setup do
      @username = "username"
      @password = "password"
      @client = Tuiter::Client.new(:username => @username, :password => @password)
    end

    context "with update invoke" do

      setup do
        @update_message = "something"
      end

      should "calls update method on twitter API" do
        # expects parse update url
        twitter_update_url = "http://twitter.com/statuses/update.json"
        uri_http = URI.parse(twitter_update_url)
        URI.expects(:parse).with(twitter_update_url).returns(uri_http)

        # expects basic authentication and set message param
        Net::HTTP::Post.any_instance.expects(:basic_auth).with(@username, @password)
        Net::HTTP::Post.any_instance.expects(:set_form_data).with('status' => @update_message, 'in_reply_to_status_id' => nil)

        # dosen't make real request
        Net::HTTP.any_instance.expects(:request).returns(Net::HTTPSuccess.new('1.1', 200, 'OK'))

        @response = @client.update(@update_message)
 
        assert_instance_of Net::HTTPSuccess, @response
      end

    end
    
  end
end
