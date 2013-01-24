#
# custom_field.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class CustomField < Component
			attr_accessor :name, :value

			# Factory method to create a CustomField object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [CustomField]
			def self.from_array(props)
				custom_field = CustomField.new
				custom_field.name = get_value(props, 'name')
				custom_field.value = get_value(props, 'value')
				custom_field
			end

		end
	end
end