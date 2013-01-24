#
# contact_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class ContactService < BaseService
			class << self

				# Get an array of contacts
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] offset - denotes the starting number for the result set
				# @param [Integer] limit - denotes the number of results per set
				# @return [Array<Contact>]
				def get_contacts(access_token, offset = nil, limit = nil)
					url = paginate_url(
						Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts'), offset, limit
					)

					contacts = []
					response = RestClient.get(url, get_headers(access_token))
					JSON.parse(response.body).each do |contact|
						contacts << Components::Contact.from_array(contact)
					end

					contacts
				end


				# Get contact details for a specific contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] contact_id - Unique contact id
				# @return [Contact]
				def get_contact(access_token, contact_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::Contact.from_array(JSON.parse(response.body))
				end


				# Get contacts with a specified email eaddress
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] email - contact email address to search for
				# @return [Array<Contact>]
				def get_contact_by_email(access_token, email)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts') + '?email=' + email
					response = RestClient.get(url, get_headers(access_token))

					contacts = []
					items = JSON.parse(response.body)
					items = [items] unless items.is_a?(Array)
					items.each do |contact|
						contacts << Components::Contact.from_array(contact)
					end
					contacts
				end


				# Add a new contact to the Constant Contact account
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Contact] contact - Contact to add
				# @return [Contact]
				def add_contact(access_token, contact)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts')
					json = contact.to_json.gsub('false', 'null')

					response = RestClient.post(url, json, get_headers(access_token))
					Components::Contact.from_array(JSON.parse(response.body))
				end


				# Delete contact details for a specific contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] contact_id - Unique contact id
				# @return [Boolean]
				def delete_contact(access_token, contact_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact_id)
					response = RestClient.delete(url, get_headers(access_token))
					response.code == 204
				end


				# Delete a contact from all contact lists
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] contact_id - Contact id to be removed from lists
				# @return [Boolean]
				def delete_contact_from_lists(access_token, contact_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact_lists'), contact_id)
					response = RestClient.delete(url, get_headers(access_token))
					response.code == 204
				end


				# Delete a contact from a specific contact list
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] contact_id - Contact id to be removed
				# @param [Integer] list_id - ContactList to remove the contact from
				# @return [Boolean]
				def delete_contact_from_list(access_token, contact_id, list_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact_list'), contact_id, list_id)
					response = RestClient.delete(url, get_headers(access_token))
					response.code == 204
				end


				# Update contact details for a specific contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Contact] contact - Contact to be updated
				# @return [Contact]
				def update_contact(access_token, contact)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact.id)
					json = contact.to_json.gsub('false', 'null')
					response = RestClient.put(url, json, get_headers(access_token))
					Components::Contact.from_array(JSON.parse(response.body))
				end

			end
		end
	end
end