# Block Methods
# [X] block_create
# [X] block_destroy
# [ ] block_exists
# [ ] block_blocking
# [ ] block_ids

module Tuiter

  module BlockMethods

    def block_create(id)
      log("block_create() blocking: #{id}")      
      res = @request_handler.post("/blocks/create/#{id}.json")

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        log("block_create() success: OK")
        return Tuiter::User.new(JSON.parse(res.body))
      else
        log("block_create() error: #{res.error!}")
        res.error!
      end
    end

    def block_destroy(id)
      log("block_destroy() unblocking: #{id}")
      res = @request_handler.delete("/blocks/destroy/#{id}.json")

      case res
      when Net::HTTPSuccess
        log("block_destroy() #{id} success: OK")
        return Tuiter::User.new(JSON.parse(res.body))
      else
        log("block_destroy() #{id} error: #{res.error!}")
        res.error!
      end
    end

  end

end

