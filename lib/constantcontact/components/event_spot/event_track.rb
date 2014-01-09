#
# event_track.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class EventTrack < Component
        attr_accessor :information_sections, :is_registration_closed_manually, :is_ticketing_link_displayed, :guest_limit, :registration_limit_count, :guest_display_label, :is_guest_name_required, :is_guest_anonymous_enabled

        # Factory method to create an event RegistrantTracking object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          obj = EventTrack.new
          props.each do |key, value|
            key = key.to_s
            obj.send("#{key}=", value) if obj.respond_to? key
          end if props
          obj
        end
      end
    end
  end
end

