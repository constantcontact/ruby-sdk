#
# verified_email_address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class VerifiedEmailAddress < Component
			attr_accessor :status, :email_address

			# Factory method to create a VerifiedEmailAddress object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [VerifiedEmailAddress]
			def self.create(props)
				email_address = VerifiedEmailAddress.new
				if props
					props.each do |key, value|
						email_address.send("#{key}=", value)
					end
				end
				email_address
			end

		end
	end
end