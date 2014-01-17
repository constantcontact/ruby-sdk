#
# promo_code.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class PromoCode < Component
      attr_accessor :discount_type, :code_type, :code_name, :redemption_count,
        :discount_scope, :discount_amount, :discount_percent

      # Factory method to create an event PromoCode object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        code = PromoCode.new
        props.each do |key, value|
          key = key.to_s
          code.send("#{key}=", value) if code.respond_to? key
        end
        code
      end
    end
  end
end