#
# click_through_details.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ClickThroughDetails < Component
      attr_accessor :url, :url_uid, :click_count


      # Factory method to create an ClickThroughDetails object from an array
      # @param [Hash] props - hash of properties to create object from
      # @return [ClickThroughDetails]
      def self.create(props)
        click_through_details = ClickThroughDetails.new
        if props
          props.each do |key, value|
            click_through_details.send("#{key}=", value)
          end
        end
        click_through_details
      end

    end
  end
end