# Account Methods
# [X] account/verify_credentials
# [ ] account/end_session
# [ ] account/update_location
# [ ] account/update_delivery_device
# [ ] account/update_profile_colors
# [ ] account/update_profile_image
# [ ] account/update_profile_background_image
# [X] account/rate_limit_status
# [ ] account/update_profile

module Tuiter
  
  module AccountMethods
    
    def account_verify_credentials?
      if res = request("http://twitter.com/account/verify_credentials.json")
        return Tuiter::UserExtended.new(JSON.parse(res))
      else
        return nil
      end
    end
    
    def account_rate_limit_status
      if res = request("http://twitter.com/account/rate_limit_status.json")
        return Tuiter::RateLimit.new(JSON.parse(res))
      else
        return nil
      end
    end
  
  end

end

