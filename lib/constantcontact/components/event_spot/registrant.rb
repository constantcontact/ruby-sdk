#
# registrant.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Registrant < Component
      attr_accessor :id, :ticket_id, :registration_status, :registration_date, :attendance_status,
        :email, :first_name, :last_name, :guest_count, :payment_status, :updated_date,
        :sale_items, :fees, :promo_code_info, :sections, :guests

      # Factory method to create an event Registrant object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        registrant = Registrant.new
        if props
          props.each do |key, value|
            key = key.to_s
            if key == 'sale_items' or key == 'fees'
              value ||= []
              registrant.send("#{key}=", value.collect{|item| Components::EventSpot::SaleItem.create item })
            elsif key == 'sections' or key == 'guest_sections'
              registrant.send("#{key}=", value.collect{|section| Components::EventSpot::RegistrantSection.create(section) })
            elsif key == 'promo_code_info'
              value ||= []
              registration.promo_code_info = value.collect{|code| Components::EventSpot::Promocode.create code }
            elsif key == 'guests'
              value = value["guest_info"] || []
              registrant.guests = value.collect{|guest| Components::EventSpot::Guest.create guest }
            else
              registrant.send("#{key}=", value) if registrant.respond_to?("#{key}=")
            end
          end
        end
        registrant
      end
      
      # Factory method to create an event Registrant summary object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create_summary(props)
        registrant = Registrant.new
        props.each do |key, value|
          key = key.to_s
          registrant.send("#{key}=", value) if registrant.respond_to?("#{key}=")
        end if props
        registrant
      end
    end
  end
end