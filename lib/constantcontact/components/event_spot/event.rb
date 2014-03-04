#
# event.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Event < Component
      attr_accessor :active_date, :address, :are_registrants_public, :cancelled_date, :contact, :created_date,
                    :currency_type, :deleted_date, :description, :end_date, :google_analytics_key, :google_merchant_id,
                    :id, :is_calendar_displayed, :is_checkin_available, :is_home_page_displayed,
                    :is_listed_in_external_directory, :is_map_displayed, :is_virtual_event, :location, :meta_data_tags,
                    :name, :notification_options, :online_meeting, :payable_to, :payment_address, :payment_options,
                    :paypal_account_email, :registration_url, :start_date, :status, :theme_name, :time_zone_description,
                    :time_zone_id, :title, :total_registered_count, :track_information, :twitter_hash_tag, :type,
                    :updated_date

      # Factory method to create an Event object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Event]
      def self.create(props)
        obj = Event.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'address'
              obj.address = Components::EventSpot::EventAddress.create(value)
            elsif key == 'contact'
              obj.contact = Components::EventSpot::Contact.create(value)
            elsif key == 'notification_options'
              value ||= []
              obj.notification_options = value.collect{|option| Components::EventSpot::NotificationOption.create(option) }
            elsif key == 'online_meeting'
              obj.online_meeting = Components::EventSpot::OnlineMeeting.create(value)
            elsif key == 'payment_adress'
              obj.payment_adress = Components::EventSpot::PaymentAddress.create(value)
            elsif key == 'payment_options'
              value ||= []
              obj.payment_options = value.collect{|option| Components::EventSpot::PaymentOption.create(option) }
            elsif key == 'track_information'
              value ||= []
              obj.track_information = Components::EventSpot::EventTrack.create(value)
            else
              obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
            end
          end
        end
        obj
      end

      # Factory method to create a summary Event object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Event]
      def self.create_summary(props)
        obj = Event.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'address'
              obj.address = Components::EventSpot::EventAddress.create(value)
            else
              obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
            end
          end
        end
        obj
      end
    end

  end
end