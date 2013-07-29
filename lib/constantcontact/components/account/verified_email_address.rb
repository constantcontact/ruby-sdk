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
				obj = VerifiedEmailAddress.new
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