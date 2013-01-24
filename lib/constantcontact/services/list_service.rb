#
# list_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class ListService < BaseService
			class << self

				# Get lists within an account
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @return [Array<ContactList>]
				def get_lists(access_token)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.lists')
					response = RestClient.get(url, get_headers(access_token))
					lists = []
					JSON.parse(response.body).each do |contact|
						lists << Components::ContactList.from_array(contact)
					end
					lists
				end


				# Add a new list to the Constant Contact account
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [ContactList] list
				# @return [ContactList]
				def add_list(access_token, list)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.lists')
					json = list.to_json.gsub('"contact_count":false', '"contact_count":null')
					response = RestClient.post(url, json, get_headers(access_token))
					Components::ContactList.from_array(JSON.parse(response.body))
				end


				# Get an individual contact list
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] list_id - list id
				# @return [ContactList]
				def get_list(access_token, list_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list'), list_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::ContactList.from_array(JSON.parse(response.body))
				end


				# Get all contacts from an individual list
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] list_id - list id to retrieve contacts for
				# @return [Array<Contact>]
				def get_contacts_from_list(access_token, list_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list_contacts'), list_id)
					response = RestClient.get(url, get_headers(access_token))
					contacts = []
					JSON.parse(response.body).each do |contact|
						contacts << Components::Contact.from_array(contact)
					end
					contacts
				end

			end
		end
	end
end