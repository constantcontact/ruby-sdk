#
# online_meeting.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class OnlineMeeting < Component
        attr_accessor :instructions, :provider_meeting_id, :provider_type, :url

        # Factory method to create an OnlineMeeting object from a json string
        # @param [Hash] props - properties to create object from
        # @return [OnlineMeeting]
        def self.create(props)
          obj = OnlineMeeting.new
          if props
            props.each do |key, value|
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end
          obj
        end
      end
    end
  end
end
