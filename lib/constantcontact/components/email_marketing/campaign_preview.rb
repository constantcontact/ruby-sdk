#
# campaign_preview.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class CampaignPreview < Component
      attr_accessor :from_email, :preview_email_content, :preview_text_content, 
                    :reply_to_email, :subject 


      # Factory method to create a CampaignPreview object from an array
      # @param [Hash] props - properties to create object from
      # @return [CampaignPreview]
      def self.create(props)
        obj = CampaignPreview.new
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