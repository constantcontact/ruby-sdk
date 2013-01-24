#
# contact_list.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class ContactList < Component
			attr_accessor :id, :name, :status, :contact_count, :opt_in_default

			# Factory method to create a ContactList object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [ContactList]
			def self.from_array(props)
				contact_list = ContactList.new
				contact_list.id = get_value(props, 'id')
				contact_list.name = get_value(props, 'name')
				contact_list.status = get_value(props, 'status')
				contact_list.contact_count = get_value(props, 'contact_count')
				contact_list.opt_in_default = get_value(props, 'opt_in_default')
				contact_list
			end

		end
	end
end