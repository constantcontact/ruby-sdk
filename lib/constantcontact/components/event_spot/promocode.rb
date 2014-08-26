#
# promocode.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Promocode < Component
      attr_accessor :code_name, :code_type, :discount_amount, :discount_percent, :discount_scope, :discount_type,
                    :fee_ids, :id, :is_paused, :quantity_available, :quantity_total, :quantity_used, :status 

      # Factory method to create an event Promocode object from a hash
      # @param [Hash] props - properties to create object from
      # @return [Promocode]
      def self.create(props)
        obj = Promocode.new
        props.each do |key, value|
          obj.send("#{key}=", value) if obj.respond_to? key
        end
        obj
      end
    end
  end
end