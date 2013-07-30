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
			def self.create(props)
				obj = CustomField.new
				if props
					props.each do |key, value|
						obj.send("#{key}=", value) if obj.respond_to? key
					end
				end
				obj
			end
		end
	end
end