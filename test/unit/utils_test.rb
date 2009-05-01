require File.dirname(__FILE__) + "/../test_helper"

class UtilsTest < Test::Unit::TestCase
  
  context "Tuiter::Request" do
    setup do
      FakeWeb.allow_net_connect = false
    end

    should "raise exception if user uses wrong authentication type" do
      assert_raise StandardError do
        Tuiter::Request.new(:wrong, {})
      end
    end
    
    context "basic authentication" do
      setup do
        @tuiter_request = Tuiter::Request.new(:basic, :username => "foo", :password => "bar")
        FakeWeb.register_uri("http://foo:bar@www.twitter.com/secret", :string => "Unauthorized", :status => ["401", "Unauthorized"])
        FakeWeb.register_uri(:get, 'http://foo:bar@www.twitter.com/', :string => "response")
        FakeWeb.register_uri(:post, 'http://foo:bar@www.twitter.com/create', :string => "created")
      end

      should "verify the authentication type correctly" do
        assert_equal true, @tuiter_request.is_basic?
        assert_equal false, @tuiter_request.is_oauth?
      end
      
      should "do a request correctly" do
        assert_equal "response", @tuiter_request.request(:get, 'http://www.twitter.com/').body
      end
      
      should "return 401 when user is not authenticated" do
        assert_equal "401", @tuiter_request.request(:get, 'http://www.twitter.com/secret').code
      end
      
      should "do a get" do
        assert_equal "response", @tuiter_request.get('/').body
      end
      
      should "do a post" do
        FakeWeb.register_uri(:post, 'http://foo:bar@www.twitter.com/create', :string => "created")
        assert_equal "created", @tuiter_request.post('/create', "status=some_status").body
      end
      
      should "do a put" do
        FakeWeb.register_uri(:any, 'http://foo:bar@www.twitter.com/change', :string => "changed")
        assert_equal "changed", @tuiter_request.put('/change', :status => "some_status").body
      end
      
      should "do a delete" do
        FakeWeb.register_uri(:delete, 'http://foo:bar@www.twitter.com/delete', :string => "deleted")
        assert_equal "deleted", @tuiter_request.delete('/delete').body
      end
      
      should "handle error if the method is wrong" do
        assert_raise ArgumentError do
          @tuiter_request.request(:head, '/check').body
        end
      end
      
    end
    
    
  end
  
  
end

