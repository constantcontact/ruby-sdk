#
# event_track.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class EventTrack < Component
        attr_accessor :early_fee_date, :guest_display_label, :guest_limit, :information_sections,
                      :is_guest_anonymous_enabled, :is_guest_name_required, :is_registration_closed_manually,
                      :is_ticketing_link_displayed, :late_fee_date, :registration_limit_count,
                      :registration_limit_date

        # Factory method to create an event EventTrack object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [EventTrack]
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

