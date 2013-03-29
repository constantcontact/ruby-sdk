#
# api.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	class Api

		# Class constructor
		# @param [String] api_key - Constant Contact API Key
		# @return
		def initialize(api_key)
			Services::BaseService.api_key = api_key
		end


		# Get verified addresses for the account
		# @param [String] access_token - Valid access token
		# @return [Array<VerifiedEmailAddress>] an array of email addresses
		def get_verified_email_addresses(access_token)
			Services::AccountService.get_verified_email_addresses(access_token)
		end


		# Get a set of contacts
		# @param [String] access_token - Valid access token
		# @param [Integer] param - denotes the number of results per set, limited to 50, 
		# or a next parameter provided from a previous call
		# @return [ResultSet<Contact>] a ResultSet of Contacts
		def get_contacts(access_token, param = nil)
			param = determine_param(param)
			Services::ContactService.get_contacts(access_token, param)
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
		# @return [ResultSet<Contact>] a ResultSet of Contacts
		def get_contact_by_email(access_token, email)
			Services::ContactService.get_contacts(access_token, {'email' => email})
		end


		# Add a new contact to an account
		# @param [String] access_token - Valid access token
		# @param [Contact] contact - Contact to add
		# @param [Boolean] action_by_visitor - if the action is being taken by the visitor
		# @return [Contact]
		def add_contact(access_token, contact, action_by_visitor = false)
			Services::ContactService.add_contact(access_token, contact, action_by_visitor)
		end


		# Sets an individual contact to 'REMOVED' status
		# @param [String] access_token - Valid access token
		# @param [Mixed] contact - Either a Contact id or the Contact itself
		# @raise [IllegalArgumentException] If contact is not an integer or a Contact object
		# @return [Boolean]
		def delete_contact(access_token, contact)
			contact_id = get_argument_id(contact, 'Contact')
			Services::ContactService.delete_contact(access_token, contact_id)
		end


		# Delete a contact from all contact lists
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or the Contact object itself
		# @raise [IllegalArgumentException] If contact is not an integer or a Contact object
		# @return [Boolean]
		def delete_contact_from_lists(access_token, contact)
			contact_id = get_argument_id(contact, 'Contact')
			Services::ContactService.delete_contact_from_lists(access_token, contact_id)
		end


		# Delete a contact from all contact lists
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or a Contact object
		# @param [Mixed] list - ContactList id or a ContactList object
		# @raise [IllegalArgumentException] If contact is not an integer or a Contact object
		# @return [Boolean]
		def delete_contact_from_list(access_token, contact, list)
			contact_id = get_argument_id(contact, 'Contact')
			list_id = get_argument_id(list, 'ContactList')
			Services::ContactService.delete_contact_from_list(access_token, contact_id, list_id)
		end


		# Update an individual contact
		# @param [String] access_token - Valid access token
		# @param [Contact] contact - Contact to update
		# @param [Boolean] action_by_visitor - if the action is being taken by the visitor
		# @return [Contact]
		def update_contact(access_token, contact, action_by_visitor = false)
			Services::ContactService.update_contact(access_token, contact, action_by_visitor)
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


		# Update a contact list
		# @param [String] access_token - Valid access token
		# @param [ContactList] list - ContactList to update
		# @return [ContactList]
		def update_list(access_token, list)
			Services::ListService.update_list(access_token, list)
		end


		# Get contact that belong to a specific list
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] list - Integer id of the list or ContactList object
		# @raise [IllegalArgumentException] If contact is not an integer or contact
		# @return [Array<Contact>] An array of contacts
		def get_contacts_from_list(access_token, list)
			list_id = get_argument_id(list, 'ContactList')
			Services::ListService.get_contacts_from_list(access_token, list_id)
		end


		# Get a set of campaigns
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [String] param - denotes the number of results per set, limited to 50, or a next parameter provided
		# from a previous call
		# @return [ResultSet<Campaign>]
		def get_email_campaigns(access_token, param = nil)
			param = determine_param(param)
			Services::EmailMarketingService.get_campaigns(access_token, param)
		end


		# Get an individual campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Integer] campaign_id - Valid campaign id
		# @return [Campaign]
		def get_email_campaign(access_token, campaign_id)
			Services::EmailMarketingService.get_campaign(access_token, campaign_id)
		end


		# Delete an individual campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Id of a campaign or a Campaign object
		# @raise IllegalArgumentException - if a Campaign object or campaign id is not passed
		# @return [Boolean]
		def delete_email_campaign(access_token, campaign)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::EmailMarketingService.delete_campaign(access_token, campaign_id)
		end


		# Create a new campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Campaign] campaign - Campaign to be created
		# @return [Campaign] - created campaign
		def add_email_campaign(access_token, campaign)
			Services::EmailMarketingService.add_campaign(access_token, campaign)
		end


		# Update a specific campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Campaign] campaign - Campaign to be updated
		# @return [Campaign] - updated campaign
		def update_email_campaign(access_token, campaign)
			Services::EmailMarketingService.update_campaign(access_token, campaign)
		end


		# Schedule a campaign to be sent
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Id of a campaign or a Campaign object
		# @param [Schedule] schedule - Schedule to be associated with the provided campaign
		# @return [Campaign] - updated campaign
		def add_email_campaign_schedule(access_token, campaign, schedule)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::CampaignScheduleService.add_schedule(access_token, campaign_id, schedule)
		end


		# Get an array of schedules associated with a given campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @return [Array<Schedule>]
		def get_email_campaign_schedules(access_token, campaign)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::CampaignScheduleService.get_schedules(access_token, campaign_id)
		end


		# Get a specific schedule associated with a given campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Mixed] schedule - Schedule id or Schedule object itself
		# @raise IllegalArgumentException
		# @return [Schedule]
		def get_email_campaign_schedule(access_token, campaign, schedule)
			campaign_id = get_argument_id(campaign, 'Campaign')
			schedule_id = get_argument_id(schedule, 'Schedule')
			Services::CampaignScheduleService.get_schedule(access_token, campaign_id, schedule_id)
		end


		# Update a specific schedule associated with a given campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Schedule] schedule - Schedule to be updated
		# @return [Schedule]
		def update_email_campaign_schedule(access_token, campaign, schedule)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::CampaignScheduleService.update_schedule(access_token, campaign_id, schedule)
		end


		# Delete a specific schedule associated with a given campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Mixed] schedule - Schedule id or Schedule object itself
		# @raise IllegalArgumentException
		# @return [Boolean]
		def delete_email_campaign_schedule(access_token, campaign, schedule)
			campaign_id = get_argument_id(campaign, 'Campaign')
			schedule_id = get_argument_id(schedule, 'Schedule')
			Services::CampaignScheduleService.delete_schedule(access_token, campaign_id, schedule_id)
		end


		# Send a test send of a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [TestSend] test_send - test send details
		# @return [TestSend]
		def send_email_campaign_test(access_token, campaign, test_send)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::CampaignScheduleService.send_test(access_token, campaign_id, test_send)
		end


		# Get sends for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [String] param - next value returned from a previous request (used in pagination)
		# @return [ResultSet<SendActivity>]
		def get_email_campaign_sends(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_sends(access_token, campaign_id, param)
		end


		# Get bounces for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign  - Campaign id or Campaign object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<BounceActivity>]
		def get_email_campaign_bounces(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_bounces(access_token, campaign_id, param)
		end


		# Get clicks for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<ClickActivity>]
		def get_email_campaign_clicks(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_clicks(access_token, campaign_id, param)
		end


		# Get opens for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign  - Campaign id or Campaign object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<OpenActivity>]
		def get_email_campaign_opens(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_opens(access_token, campaign_id, param)
		end


		# Get forwards for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<ForwardActivity>]
		def get_email_campaign_forwards(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_forwards(access_token, campaign_id, param)
		end


		# Get unsubscribes for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign - Campaign id or Campaign object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<UnsubscribeActivity>] - Containing a results array of UnsubscribeActivity
		def get_email_campaign_unsubscribes(access_token, campaign, param = nil)
			campaign_id = get_argument_id(campaign, 'Campaign')
			param = determine_param(param)
			Services::CampaignTrackingService.get_unsubscribes(access_token, campaign_id, param)
		end


		# Get a reporting summary for a campaign
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] campaign  - Campaign id or Campaign object itself
		# @return [TrackingSummary]
		def get_email_campaign_summary_report(access_token, campaign)
			campaign_id = get_argument_id(campaign, 'Campaign')
			Services::CampaignTrackingService.get_summary(access_token, campaign_id)
		end


		# Get sends for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or Contact object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<SendActivity>]
		def get_contact_sends(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			Services::ContactTrackingService.get_sends(access_token, contact_id, param)
		end


		# Get bounces for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or Contact object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<BounceActivity>]
		def get_contact_bounces(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			Services::ContactTrackingService.get_bounces(access_token, contact_id, param)
		end


		# Get clicks for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or Contact object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<ClickActivity>]
		def get_contact_clicks(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			param = determine_param(param)
			Services::ContactTrackingService.get_clicks(access_token, contact_id, param)
		end


		# Get opens for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact  - Contact id or Contact object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<OpenActivity>]
		def get_contact_opens(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			param = determine_param(param)
			Services::ContactTrackingService.get_opens(access_token, contact_id, param)
		end


		# Get forwards for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact  - Contact id or Contact object itself
		# @param [Mixed] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [ResultSet<ForwardActivity>]
		def get_contact_forwards(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			param = determine_param(param)
			Services::ContactTrackingService.get_forwards(access_token, contact_id, param)
		end


		# Get unsubscribes for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or Contact object itself
		# @param [Hash] param - either the next link from a previous request, or a limit or restrict the page size of
		# an initial request
		# @return [UnsubscribeActivity] - Containing a results array of UnsubscribeActivity
		def get_contact_unsubscribes(access_token, contact, param = nil)
			contact_id = get_argument_id(contact, 'Contact')
			param = determine_param(param)
			Services::ContactTrackingService.get_unsubscribes(access_token, contact_id, param)
		end


		# Get a reporting summary for a Contact
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Mixed] contact - Contact id or Contact object itself
		# @return [TrackingSummary]
		def get_contact_summary_report(access_token, contact)
			contact_id = get_argument_id(contact, 'Contact')
			Services::ContactTrackingService.get_summary(access_token, contact_id)
		end


		# Get an array of activities
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @return [Array<Activity>]
		def get_activities(access_token)
			Services::ActivityService.get_activities(access_token)
		end


		# Get a single activity by id
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [String] activity_id - Activity id
		# @return [Activity]
		def get_activity(access_token, activity_id)
			Services::ActivityService.get_activity(access_token, activity_id)
		end


		# Add an AddContacts activity to add contacts in bulk
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [AddContacts] add_contacts - Add Contacts
		# @return [Activity]
		def add_add_contacts_activity(access_token, add_contacts)
			Services::ActivityService.create_add_contacts_activity(access_token, add_contacts)
		end


		# Add a ClearLists Activity to remove all contacts from the provided lists
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Array<Lists>] lists - Add Contacts Activity
		# @return [Activity]
		def add_clear_lists_activity(access_token, lists)
			Services::ActivityService.add_clear_lists_activity(access_token, lists)
		end


		# Add a Remove Contacts From Lists Activity
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [Array<EmailAddress>] email_addresses - email addresses to be removed
		# @param [Array<Lists>] lists - lists to remove the provided email addresses from
		# @return [Activity]
		def add_remove_contacts_from_lists_activity(access_token, email_addresses, lists)
			Services::ActivityService.add_remove_contacts_from_lists_activity(access_token, email_addresses, lists)
		end


		# Create an Export Contacts Activity
		# @param [String] access_token - Constant Contact OAuth2 access token
		# @param [<Array>Contacts] export_contacts - Contacts to be exported
		# @return [Activity]
		def add_export_contacts_activity(access_token, export_contacts)
			Services::ActivityService.add_export_contacts_activity(access_token, export_contacts)
		end


		private


		# Get the id of object, or attempt to convert the argument to an int
		# @param [Mixed] item - object or a numeric value
		# @param [String] class_name - class name to test the given object against
		# @raise IllegalArgumentException - if the item is not an instance of the class name given, or cannot be
		# converted to a numeric value
		# @return [Integer]
		def get_argument_id(item, class_name)
			item_id = nil
			if item.is_a?(Integer)
				item_id = item
			elsif item.class.to_s.split('::').last == class_name
				item_id = item.id
			else
				raise Exceptions::IllegalArgumentException.new(sprintf(Util::Config.get('errors.id_or_object'), class_name))
			end
			item_id
		end


		# Append the limit parameter, if the value is an integer
		# @param [String] param - parameter value
		# @return [Hash] the parameters as a hash object
		def determine_param(param)
			params = {}
			if param
				param = param.to_s
				if param[0, 1] == '?'
					hash_params = CGI::parse(param[1..-1])
					params = Hash[*hash_params.collect {|key, value| [key, value.first] }.flatten]
				else
					params['limit'] = param
				end
			end
			params
		end

	end
end
