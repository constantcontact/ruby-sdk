#
# api.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	class Api
		attr_reader :api_key


		# Class constructor
		# @param [String] api_key - Constant Contact API Key
		# @return
		def initialize(api_key)
			@api_key = api_key
		end


		# Get a set of contacts
		# @param [String] access_token - Valid access token
		# @param [Integer] offset - denotes the starting number for the result set
		# @param [Integer] limit - denotes the number of results per set, limited to 50
		# @return [Array<Contact>] Array of Contacts
		def get_contacts(access_token, offset = nil, limit = nil)
			Services::ContactService.get_contacts(access_token, offset, limit)
		end


		# Get an individual contact
		# @param [String] access_token - Valid access token
		# @param [Integer] contact_id - Id of the contact to retrieve
		# @return [Contact]
		def get_contact(access_token, contact_id)
			Services::ContactService.get_contact(access_token, contact_id)
		end


		# Get contacts with a specified email eaddress
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [String] email - contact email address to search for
		# @return [Array<Contact>] Array of Contacts
		def get_contact_by_email(access_token, email)
			Services::ContactService.get_contact_by_email(access_token, email)
		end


		# Add a new contact to an account
		# @param [String] access_token - Valid access token
		# @param [Contact] contact - Contact to add
		# @return [Contact]
		def add_contact(access_token, contact)
			Services::ContactService.add_contact(access_token, contact)
		end


		# Sets an individual contact to 'REMOVED' status
		# @param [String] access_token - Valid access token
		# @param [Integer or Contact] contact - Either a Contact id or the Contact itself
		# @raise [IllegalArgumentException] If contact is not an integer or contact
		# @return [Boolean]
		def delete_contact(access_token, contact)
			if contact.instance_of?(Components::Contact)
				return Services::ContactService.delete_contact(access_token, contact.id)
			elsif contact.is_a?(Integer)
				return Services::ContactService.delete_contact(access_token, contact)
			else
				raise Exceptions::IllegalArgumentException.new(Util::Config.get('errors.contact_or_id'))
			end
		end


		# Delete a contact from all contact lists
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Integer or Contact] contact - Contact id or the Contact object itself
		# @raise [IllegalArgumentException] If contact is not an integer or contact
		# @return [Boolean]
		def delete_contact_from_lists(access_token, contact)
			if contact.instance_of?(Components::Contact)
				return Services::ContactService.delete_contact_from_lists(access_token, contact.id)
			elsif contact.is_a?(Integer)
				return Services::ContactService.delete_contact_from_lists(access_token, contact)
			else
				raise Exceptions::IllegalArgumentException.new(Util::Config.get('errors.contact_or_id'))
			end
		end


		# Delete a contact from all contact lists
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Integer or Contact] contact - Contact id or a Contact object
		# @param [Integer or ContactList] list - ContactList id or a ContactList object
		# @raise [IllegalArgumentException] If contact is not an integer or contact
		# @return [Boolean]
		def delete_contact_from_list(access_token, contact, list)
			contact_id = nil
			list_id = nil

			# determine contact id
			if contact.instance_of?(Components::Contact)
				contact_id = contact.id
			elsif contact.is_a?(Integer)
				contact_id = contact
			else
				raise Exceptions::IllegalArgumentException.new(Util::Config.get('errors.contact_or_id'))
			end

			# determine list id
			if list.instance_of?(Components::ContactList)
				list_id = list.id
			elsif list.is_a?(Integer)
				list_id = list
			else
				raise Exceptions::IllegalArgumentException.new(Util::Config.get('errors.list_or_id'))
			end

			Services::ContactService.delete_contact_from_list(access_token, contact_id, list_id)
		end


		# Update an individual contact
		# @param [String] access_token - Valid access token
		# @param [Contact] contact - Contact to update
		# @return [Contact]
		def update_contact(access_token, contact)
			Services::ContactService.update_contact(access_token, contact)
		end


		# Get lists
		# @param [String] access_token - Valid access token
		# @return [Array<ContactList>] Array of ContactList objects
		def get_lists(access_token)
			Services::ListService.get_lists(access_token)
		end


		# Get an individual list
		# @param [String] access_token - Valid access token
		# @param [Integer] list_id - Id of the list to retrieve
		# @return [ContactList]
		def get_list(access_token, list_id)
			Services::ListService.get_list(access_token, list_id)
		end


		# Add a new list to an account
		# @param [String] access_token - Valid access token
		# @param [ContactList] list - List to add
		# @return [ContactList]
		def add_list(access_token, list)
			Services::ListService.add_list(access_token, list)
		end


		# Get contact that belong to a specific list
		# @param access_token - Constant Contact OAuth2 access token
		# @param list - Id of the list or a ContactList object
		# @raise [IllegalArgumentException] If contact is not an integer or contact
		# @return [Array<Contact>] An array of contacts
		def get_contacts_from_list(access_token, list)
			if list.instance_of?(Components::ContactList)
				return Services::ListService.get_contacts_from_list(access_token, list.id)
			elsif list.is_a?(Integer)
				return Services::ListService.get_contacts_from_list(access_token, list)
			else
				raise Exceptions::IllegalArgumentException.new(Util::Config.get('errors.list_or_id'))
			end
		end

	end
end
