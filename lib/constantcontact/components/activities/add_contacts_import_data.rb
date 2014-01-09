#
# add_contacts_import_data.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class AddContactsImportData < Component
			attr_accessor :first_name, :middle_name, :last_name, :job_title, :company_name,
										:work_phone, :home_phone, :email_addresses, :addresses, :custom_fields


			# Constructor to create an AddContactsImportData object from the given hash
			# @param [Hash] props - the hash with properties
			# @return [AddContactsImportData]
			def initialize(props = {})
				instance_variables.each do |property, value|
					send("#{property}=", get_value(props, property)) if obj.respond_to? property
				end
			end

			# Setter
			def add_custom_field(custom_field)
				@custom_fields = [] if @custom_fields.nil?
				@custom_fields << custom_field
			end


			# Setter
			def add_address(address)
				@addresses = [] if @addresses.nil?
				@addresses << address
			end


			# Setter
			def add_email(email_address)
				@email_addresses = [] if @email_addresses.nil?
				@email_addresses << email_address
			end
		end
	end
end
