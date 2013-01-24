#
# address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class Address < Component
			attr_accessor :line1, :line2, :line3, :city, :address_type, :state_code,
										:country_code, :postal_code, :sub_postal_code

			# Factory method to create an Address object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [Address]
			def self.from_array(props)
				address = Address.new
				address.line1 = get_value(props, 'line1')
				address.line2 = get_value(props, 'line2')
				address.line3 = get_value(props, 'line3')
				address.city = get_value(props, 'city')
				address.address_type = get_value(props, 'address_type')
				address.state_code = get_value(props, 'state_code')
				address.country_code = get_value(props, 'country_code')
				address.postal_code = get_value(props, 'postal_code')
				address.sub_postal_code = get_value(props, 'sub_postal_code')
				address
			end

		end
	end
end
