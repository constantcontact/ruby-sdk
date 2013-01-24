#
# contact.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class Contact < Component

			attr_accessor :id, :status, :first_name, :middle_name, :last_name, :confirmed, :email_addresses,
									:prefix_name, :job_title, :addresses, :company_name, :home_phone,
									:work_phone, :cell_phone, :fax, :custom_fields, :last_update_time, :lists,
									:source_details, :source_is_url, :action_by, :web_url


			# Factory method to create a Contact object from a json string
			# @param [Hash] props - JSON string representing a contact
			# @return [Contact]
			def self.from_array(props)
				contact = Contact.new

				contact.id = get_value(props, 'id')
				contact.status = get_value(props, 'status')
				contact.first_name = get_value(props, 'first_name')
				contact.middle_name = get_value(props, 'middle_name')
				contact.last_name = get_value(props, 'last_name')
				contact.confirmed = get_value(props, 'confirmed')

				contact.email_addresses = []
				if props['email_addresses']
					props['email_addresses'].each do |email_address|
						contact.email_addresses << Components::EmailAddress.from_array(email_address)
					end
				end

				contact.prefix_name = get_value(props, 'prefix_name')
				contact.job_title = get_value(props, 'job_title')
				#contact.department_name = get_value(props, 'department_name')

				contact.addresses = []
				if props['addresses']
					props['addresses'].each do |address|
						contact.addresses << Components::Address.from_array(address)
					end
				end

				contact.company_name = get_value(props, 'company_name')
				contact.home_phone = get_value(props, 'home_phone')
				contact.work_phone = get_value(props, 'work_phone')
				contact.cell_phone = get_value(props, 'cell_phone')
				contact.fax = get_value(props, 'fax')

				contact.custom_fields = []
				if props['custom_fields']
					props['custom_fields'].each do |custom_field|
						contact.custom_fields << Components::CustomField.from_array(custom_field)
					end
				end

				contact.last_update_time = get_value(props, 'last_update_time')

				contact.lists = []
				if props['lists']
					props['lists'].each do |contact_list|
						contact.lists << Components::ContactList.from_array(contact_list)
					end
				end

				contact.source_details = get_value(props, 'source_details')
				contact.source_is_url = get_value(props, 'source_is_url')
				contact.action_by = get_value(props, 'action_by')
				contact.web_url = get_value(props, 'web_url')

				contact
			end

			# Setter
			# @param [ContactList] contact_list
			def add_list(contact_list)
				@lists << contact_list
			end


			# Setter
			# @param [EmailAddress] email_address
			def add_email(email_address)
				@email_addresses << email_address
			end


			# Setter
			# @param [Address] address
			def add_address(address)
				@addresses << address
			end

		end
	end
end