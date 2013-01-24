#
# email_address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class EmailAddress < Component
			attr_accessor :status, :confirm_status, :opt_in_source, :opt_in_date, :opt_out_date, :email_address

			# Class constructor
			# @param [String] email_address
			# @return
			def initialize(email_address = nil)
				@email_address = email_address if email_address
			end

			# Factory method to create an EmailAddress object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [EmailAddress]
			def self.from_array(props)
				email_address = EmailAddress.new
				email_address.status = get_value(props, 'status')
				email_address.confirm_status = get_value(props, 'confirm_status')
				email_address.opt_in_source = get_value(props, 'opt_in_source')
				email_address.opt_in_date = get_value(props, 'opt_in_date')
				email_address.opt_out_date = get_value(props, 'opt_out_date')
				email_address.email_address = get_value(props, 'email_address')
				email_address
			end

		end
	end
end