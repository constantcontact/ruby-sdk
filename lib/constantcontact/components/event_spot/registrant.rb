#
# registrant.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Registrant < Component
      attr_accessor :attendance_status, :email, :first_name, :guest_count, :id, :last_name, :payment_status,
                    :registration_date, :registration_status, :ticket_id, :updated_date,
                    :payment_summary, :promo_code, :sections, :guests

      # Factory method to create an event Registrant object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        obj = Registrant.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'payment_summary'
              obj.payment_summary = Components::EventSpot::PaymentSummary.create(value)
            elsif key == 'sections'
              obj.sections = value.collect{|section| Components::EventSpot::RegistrantSection.create(section) }
            elsif key == 'promo_code'
              obj.promo_code = Components::EventSpot::RegistrantPromoCode.create(value)
            elsif key == 'guests'
              value = value["guest_info"] || []
              obj.guests = value.collect{|guest| Components::EventSpot::Guest.create(guest) }
            else
              obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
            end
          end
        end
        obj
      end

      # Factory method to create an event Registrant summary object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Registrant]
      def self.create_summary(props)
        obj = Registrant.new
        props.each do |key, value|
          key = key.to_s
          obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
        end if props
        obj
      end
    end
  end
end