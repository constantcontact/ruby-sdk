#
# email_campaign.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Campaign < Component
      attr_accessor :id, :name, :subject, :status, :from_name, :from_email, :reply_to_email, :template_type,
                    :created_date, :modified_date, :last_run_date, :next_run_date,
                    :is_permission_reminder_enabled, :permission_reminder_text,
                    :is_view_as_webpage_enabled, :view_as_web_page_text, :view_as_web_page_link_text,
                    :greeting_salutations, :greeting_name, :greeting_string, :email_content, :text_content,
                    :message_footer, :tracking_summary, :email_content_format, :style_sheet, :sent_to_contact_lists,
                    :click_through_details, :include_forward_email, :is_visible_in_ui


      # Factory method to create an EmailCampaign object from an array
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        campaign = Campaign.new
        if props
          props.each do |key, value|
            if key == 'message_footer'
              campaign.message_footer = Components::MessageFooter.create(value)
            elsif key == 'tracking_summary'
              campaign.tracking_summary = Components::TrackingSummary.create(value)
            elsif key == 'sent_to_contact_lists'
              if value
                campaign.sent_to_contact_lists = []
                value.each do |sent_to_contact_list|
                  campaign.sent_to_contact_lists << Components::ContactList.create(sent_to_contact_list)
                end
              end
            elsif key == 'click_through_details'
              if value
                campaign.click_through_details = []
                value.each do |click_through_details|
                  campaign.click_through_details << Components::ClickThroughDetails.create(click_through_details)
                end
              end
            else
              campaign.send("#{key}=", value)
            end
          end
        end
        campaign
      end


      # Factory method to create a Campaign object from an array
      # @param [Hash] props - hash of initial properties to set
      # @return [Campaign]
      def self.create_summary(props)
        campaign = Campaign.new
        if props
          props.each do |key, value|
            campaign.send("#{key}=", value)
          end
        end
        campaign
      end


      # Add a contact list to set of lists associated with this email
      # @param [Mixed] contact_list - Contact list id, or ContactList object
      def add_list(contact_list)
        if contact_list.instance_of?(ContactList)
          list = contact_list
        elsif contact_list.to_i.to_s == contact_list
          list = ContactList.new(contact_list)
        else
          raise Exceptions::IllegalArgumentException, sprintf(Util::Config.get('errors.id_or_object'), 'ContactList')
        end

        @sent_to_contact_lists << list
      end

    end
  end
end