#
# activity_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class ActivityService < BaseService
			class << self

				# Get a set of activities
				# @param [String] access_token
				# @return [Array<Activity>]
				def get_activities(access_token)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.activities')
					response = RestClient.get(url, get_headers(access_token))

					activities = []
					JSON.parse(response.body).each do |activity|
						activities << Components::Activity.create(activity)
					end

					activities
				end


				# Get an array of activities
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] activity_id - Activity id
				# @return [Activity]
				def get_activity(access_token, activity_id)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.activity'), activity_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::Activity.create(JSON.parse(response.body))
				end


				# Create an Add Contacts Activity
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [AddContacts] add_contacts
				# @return [Activity]
				def create_add_contacts_activity(access_token, add_contacts)
					url = Util::Config.get('endpoints.base_url') + 
								Util::Config.get('endpoints.add_contacts_activity')
					payload = add_contacts.to_json
					response = RestClient.post(url, payload, get_headers(access_token))
					Components::Activity.create(JSON.parse(response.body))
				end


				# Create a Clear Lists Activity
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Array<lists>] lists - array of list id's to be cleared
				# @return [Activity]
				def add_clear_lists_activity(access_token, lists)
					url = Util::Config.get('endpoints.base_url') + 
								Util::Config.get('endpoints.clear_lists_activity')
					payload = {'lists' => lists}.to_json
					response = RestClient.post(url, payload, get_headers(access_token))
					Components::Activity.create(JSON.parse(response.body))
				end


				# Create an Export Contacts Activity
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [ExportContacts] export_contacts
				# @return [Activity]
				def add_export_contacts_activity(access_token, export_contacts)
					url = Util::Config.get('endpoints.base_url') + 
								Util::Config.get('endpoints.export_contacts_activity')
					payload = export_contacts.to_json
					response = RestClient.post(url, payload, get_headers(access_token))
					Components::Activity.create(JSON.parse(response.body))
				end


				# Create a Remove Contacts From Lists Activity
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [<Array>EmailAddress] email_addresses
				# @param [<Array>RemoveFromLists] lists
				# @return [Activity]
				def add_remove_contacts_from_lists_activity(access_token, email_addresses, lists)
					url = Util::Config.get('endpoints.base_url') + 
								Util::Config.get('endpoints.remove_from_lists_activity')

					payload = { 'import_data' => [], 'lists' => lists }
					email_addresses.each do |email_address|
						payload['import_data'] << { 'email_addresses' => [email_address] }
					end
					payload = payload.to_json

					response = RestClient.post(url, payload, get_headers(access_token))
					Components::Activity.create(JSON.parse(response.body))
				end

			end
		end
	end
end