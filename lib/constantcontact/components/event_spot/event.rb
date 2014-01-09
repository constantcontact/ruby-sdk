#
# event.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Event < Component
      attr_accessor :id, :type, :name, :title, :status, :description, :active_date, :start_date, :end_date,
                    :deleted_date, :created_date, :modified_date, :time_zone_id, :location, :currency_type,
                    :is_checkin_available, :total_registered_count, :registration_url, :theme_name,
                    :is_virtual_event, :notification_options, :is_home_page_displayed, :is_map_displayed,
                    :is_calendar_displayed, :is_listed_in_external_directory, :are_registrants_public,
                    :track_information, 
                    :contact, :address

      # Factory method to create an Event object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        event = Event.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'address'
              event.address = Components::Address.create(value)
            elsif key == 'contact'
              event.contact = Components::EventSpot::Contact.create(value)
            elsif key == 'notification_options'
              value ||= []
              event.notification_options = value.collect{|notification| Components::EventSpot::NotificationOption.create notification }
            elsif key == 'track_information'
              value ||= []
              event.track_information = Components::EventSpot::EventTrack.create value
            else
              event.send("#{key}=", value) if event.respond_to?("#{key}=")
            end
          end
        end
        event
      end
      
      # Factory method to create an summary Event object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create_summary(props)
        event = Event.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'address'
              event.address = Components::Address.create(value)
            else
              event.send("#{key}=", value) if event.respond_to?("#{key}=")
            end
          end
        end
        event
      end
    end
  end
end