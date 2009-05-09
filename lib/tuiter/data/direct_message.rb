module Tuiter

  class DirectMessageBasic
    attr_accessor :id
    attr_accessor :text
    attr_accessor :created_at
    attr_accessor :sender_id
    attr_accessor :sender_screen_name
    attr_accessor :recipient_id
    attr_accessor :recipient_screen_name

    def initialize(data = nil)
      unless data.nil?
        @id = data['id']
        @text = data['text']
        @created_at = (data['created_at'] ? DateTime.parse(data['created_at']) : DateTime.now)
        @sender_id = data['sender_id']
        @sender_screen_name = data['sender_screen_name']
        @recipient_id = data['recipient_id']
        @recipient_screen_name = data['recipient_screen_name']
      else
        @created_at = DateTime.now
      end
    end

  end


  class DirectMessage < DirectMessageBasic
    attr_accessor :sender
    attr_accessor :recipient

    def initialize(data = nil)
      unless data.nil?
        super(data)
        @sender = User.new(data['sender'])
        @recipient = User.new(data['recipient'])
      end
    end

  end

end

