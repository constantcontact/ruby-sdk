#
# test_send.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class TestSend < Component
			attr_accessor :format, :personal_message, :email_addresses


			# Factory method to create a TestSend object from an array
			# @param [Hash] props - hash of properties to create object from
			# @return [TestSend]
			def self.create(props)
				obj = TestSend.new
				if props
					props.each do |key, value|
						if key == 'email_addresses'
							if value
								obj.email_addresses = []
								value.each do |email_address|
									obj.email_addresses << email_address
								end
							end
						else
							obj.send("#{key}=", value) if obj.respond_to? key
						end
					end
				end
				obj
			end


			# Add an email address to the set of addresses to send the test send too
			# @param [String] email_address
			def add_email(email_address)
				@email_addresses = [] if @email_addresses.nil?
				@email_addresses << email_address
			end

		end
	end
end