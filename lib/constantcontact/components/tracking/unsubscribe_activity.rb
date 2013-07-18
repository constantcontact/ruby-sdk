#
# unsubscribe_activity.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class UnsubscribeActivity < Component
      attr_accessor :activity_type, :campaign_id, :contact_id, :email_address, :unsubscribe_date,
                    :unsubscribe_source, :unsubscribe_reason


      # Factory method to create an UnsubscribeActivity object from an array
      # @param [Hash] props - hash of properties to create object from
      # @return [UnsubscribeActivity]
      def self.create(props)
        unsubscribe_activity = UnsubscribeActivity.new
        if props
          props.each do |key, value|
            unsubscribe_activity.send("#{key}=", value)
          end
        end
        unsubscribe_activity
      end

    end
  end
end