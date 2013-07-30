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
                    :work_phone, :cell_phone, :fax, :custom_fields, :lists,
                    :source_details, :source_is_url, :web_url, :modified_date,
                    :created_date, :notes, :source


			# Factory method to create a Contact object from a json string
			# @param [Hash] props - JSON string representing a contact
			# @return [Contact]
			def self.create(props)
				obj = Contact.new
				if props
					props.each do |key, value|
						if key == 'email_addresses'
							if value
								obj.email_addresses = []
								value.each do |email_address|
									obj.email_addresses << Components::EmailAddress.create(email_address)
								end
							end
						elsif key == 'addresses'
							if value
								obj.addresses = []
								value.each do |address|
									obj.addresses << Components::Address.create(address)
								end
							end
						elsif key == 'custom_fields'
							if value
								obj.custom_fields = []
								value.each do |custom_field|
									obj.custom_fields << Components::CustomField.create(custom_field)
								end
							end
						elsif key == 'lists'
							if value
								obj.lists = []
								value.each do |contact_list|
									obj.lists << Components::ContactList.create(contact_list)
								end
							end
						else
							obj.send("#{key}=", value) if obj.respond_to? key
						end
					end
				end
				obj
			end

      # Setter
      # @param [ContactList] contact_list
      def add_list(contact_list)
        @lists = [] if @lists.nil?
        @lists << contact_list
      end


      # Setter
      # @param [EmailAddress] email_address
      def add_email(email_address)
        @email_addresses = [] if @email_addresses.nil?
        @email_addresses << email_address
      end


      # Setter
      # @param [Address] address
      def add_address(address)
        @addresses = [] if @addresses.nil?
        @addresses << address
      end

    end
  end
end