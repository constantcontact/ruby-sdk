#
# api.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  class Api
    # Class constructor
    # @param [String] api_key - Constant Contact API Key
    # @param [String] access_token - Constant Contact OAuth2 access token
    # @return
    def initialize(api_key = nil, access_token = nil)
      Services::BaseService.api_key = api_key || Util::Config.get('auth.api_key')
      Services::BaseService.access_token = access_token
      if Services::BaseService.api_key.nil? || Services::BaseService.api_key == ''
        raise ArgumentError.new(Util::Config.get('errors.api_key_missing'))
      end
      if Services::BaseService.access_token.nil? || Services::BaseService.access_token == ''
        raise ArgumentError.new(Util::Config.get('errors.access_token_missing'))
      end
    end


    # Get a summary of account information
    # @return [AccountInfo]
    def get_account_info()
      Services::AccountService.get_account_info()
    end


    # Get verified addresses for the account
    # @param [String] status - status to filter query results by
    # @return [Array<VerifiedEmailAddress>] an array of email addresses
    def get_verified_email_addresses(status = nil)
      params = {}
      params['status'] = status if status
      Services::AccountService.get_verified_email_addresses(params)
    end


    # Get a set of contacts
    # @param [Hash] params - hash of query parameters and values to append to the request.
    # Allowed parameters include:
    #    limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #    modified_since - ISO-8601 formatted timestamp.
    #    next - the next link returned from a previous paginated call. May only be used by itself.
    #    email - the contact by email address to retrieve information for.
    #    status - a contact status to filter results by. Must be one of ACTIVE, OPTOUT, REMOVED, UNCONFIRMED.
    # @return [ResultSet<Contact>] a ResultSet of Contacts
    def get_contacts(params = {})
      Services::ContactService.get_contacts(params)
    end


    # Get an individual contact
    # @param [Integer] contact_id - Id of the contact to retrieve
    # @return [Contact]
    def get_contact(contact_id)
      Services::ContactService.get_contact(contact_id)
    end


    # Get contacts with a specified email eaddress
    # @param [String] email - contact email address to search for
    # @return [ResultSet<Contact>] a ResultSet of Contacts
    def get_contact_by_email(email)
      Services::ContactService.get_contacts({'email' => email})
    end


    # Add a new contact to an account
    # @param [Contact] contact - Contact to add
    # @param [Boolean] action_by_visitor - if the action is being taken by the visitor
    # @return [Contact]
    def add_contact(contact, action_by_visitor = false)
      params = {}
      params['action_by'] = 'ACTION_BY_VISITOR' if action_by_visitor
      Services::ContactService.add_contact(contact, params)
    end


    # Sets an individual contact to 'REMOVED' status
    # @param [Mixed] contact - Either a Contact id or the Contact itself
    # @raise [IllegalArgumentException] If contact is not an integer or a Contact object
    # @return [Boolean]
    def delete_contact(contact)
      contact_id = to_id(contact, 'Contact')
      Services::ContactService.delete_contact(contact_id)
    end


    # Delete a contact from all contact lists
    # @param [Mixed] contact - Contact id or the Contact object itself
    # @raise [IllegalArgumentException] If contact is not an integer or a Contact object
    # @return [Boolean]
    def delete_contact_from_lists(contact)
      contact_id = to_id(contact, 'Contact')
      Services::ContactService.delete_contact_from_lists(contact_id)
    end


    # Delete a contact from all contact lists
    # @param [Mixed] contact - Contact id or a Contact object
    # @param [Mixed] list - ContactList id or a ContactList object
    # @raise [IllegalArgumentException] If contact is not an integer or a Contact object
    # @return [Boolean]
    def delete_contact_from_list(contact, list)
      contact_id = to_id(contact, 'Contact')
      list_id = to_id(list, 'ContactList')
      Services::ContactService.delete_contact_from_list(contact_id, list_id)
    end


    # Update an individual contact
    # @param [Contact] contact - Contact to update
    # @param [Boolean] action_by_visitor - if the action is being taken by the visitor
    # @return [Contact]
    def update_contact(contact, action_by_visitor = false)
      params = {}
      params['action_by'] = 'ACTION_BY_VISITOR' if action_by_visitor
      Services::ContactService.update_contact(contact, params)
    end


    # Get lists
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     - modified_since - ISO-8601 formatted timestamp.
    # @return [Array<ContactList>] Array of ContactList objects
    def get_lists(params = {})
      Services::ListService.get_lists(params)
    end


    # Get an individual list
    # @param [Integer] list_id - Id of the list to retrieve
    # @return [ContactList]
    def get_list(list_id)
      Services::ListService.get_list(list_id)
    end


    # Add a new list to an account
    # @param [ContactList] list - List to add
    # @return [ContactList]
    def add_list(list)
      Services::ListService.add_list(list)
    end


    # Update a contact list
    # @param [ContactList] list - ContactList to update
    # @return [ContactList]
    def update_list(list)
      Services::ListService.update_list(list)
    end


    # Get contact that belong to a specific list
    # @param [Mixed] list - Integer id of the list or ContactList object
    # @param [Mixed] param - denotes the number of results per set, limited to 50, or a next parameter provided
    # from a previous getContactsFromList call
    # @raise [IllegalArgumentException] If contact is not an integer or contact
    # @return [Array<Contact>] An array of contacts
    def get_contacts_from_list(list, param = nil)
      list_id = to_id(list, 'ContactList')
      param = determine_param(param)
      Services::ListService.get_contacts_from_list(list_id, param)
    end


    # Get a set of campaigns
    # @param [Mixed] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     modified_since - ISO-8601 formatted timestamp.
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    #     email - the contact by email address to retrieve information for
    # @return [ResultSet<Campaign>]
    def get_email_campaigns(params = {})
      Services::EmailMarketingService.get_campaigns(params)
    end


    # Get an individual campaign
    # @param [Integer] campaign_id - Valid campaign id
    # @return [Campaign]
    def get_email_campaign(campaign_id)
      Services::EmailMarketingService.get_campaign(campaign_id)
    end


    # Delete an individual campaign
    # @param [Mixed] campaign - Id of a campaign or a Campaign object
    # @raise IllegalArgumentException - if a Campaign object or campaign id is not passed
    # @return [Boolean]
    def delete_email_campaign(campaign)
      campaign_id = to_id(campaign, 'Campaign')
      Services::EmailMarketingService.delete_campaign(campaign_id)
    end


    # Create a new campaign
    # @param [Campaign] campaign - Campaign to be created
    # @return [Campaign] - created campaign
    def add_email_campaign(campaign)
      Services::EmailMarketingService.add_campaign(campaign)
    end


    # Update a specific campaign
    # @param [Campaign] campaign - Campaign to be updated
    # @return [Campaign] - updated campaign
    def update_email_campaign(campaign)
      Services::EmailMarketingService.update_campaign(campaign)
    end


    # Schedule a campaign to be sent
    # @param [Mixed] campaign - Id of a campaign or a Campaign object
    # @param [Schedule] schedule - Schedule to be associated with the provided campaign
    # @return [Campaign] - updated campaign
    def add_email_campaign_schedule(campaign, schedule)
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignScheduleService.add_schedule(campaign_id, schedule)
    end


    # Get an array of schedules associated with a given campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @return [Array<Schedule>]
    def get_email_campaign_schedules(campaign)
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignScheduleService.get_schedules(campaign_id)
    end


    # Get a specific schedule associated with a given campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Mixed] schedule - Schedule id or Schedule object itself
    # @raise IllegalArgumentException
    # @return [Schedule]
    def get_email_campaign_schedule(campaign, schedule)
      campaign_id = to_id(campaign, 'Campaign')
      schedule_id = to_id(schedule, 'Schedule')
      Services::CampaignScheduleService.get_schedule(campaign_id, schedule_id)
    end


    # Update a specific schedule associated with a given campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Schedule] schedule - Schedule to be updated
    # @return [Schedule]
    def update_email_campaign_schedule(campaign, schedule)
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignScheduleService.update_schedule(campaign_id, schedule)
    end


    # Delete a specific schedule associated with a given campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Mixed] schedule - Schedule id or Schedule object itself
    # @raise IllegalArgumentException
    # @return [Boolean]
    def delete_email_campaign_schedule(campaign, schedule)
      campaign_id = to_id(campaign, 'Campaign')
      schedule_id = to_id(schedule, 'Schedule')
      Services::CampaignScheduleService.delete_schedule(campaign_id, schedule_id)
    end


    # Send a test send of a campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [TestSend] test_send - test send details
    # @return [TestSend]
    def send_email_campaign_test(campaign, test_send)
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignScheduleService.send_test(campaign_id, test_send)
    end


    # Get sends for a campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<SendActivity>]
    def get_email_campaign_sends(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_sends(campaign_id, params)
    end


    # Get bounces for a campaign
    # @param [Mixed] campaign  - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<BounceActivity>]
    def get_email_campaign_bounces(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_bounces(campaign_id, params)
    end


    # Get clicks for a campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<ClickActivity>]
    def get_email_campaign_clicks(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_clicks(campaign_id, params)
    end


    # Get opens for a campaign
    # @param [Mixed] campaign  - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<OpenActivity>]
    def get_email_campaign_opens(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_opens(campaign_id, params)
    end


    # Get forwards for a campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<ForwardActivity>]
    def get_email_campaign_forwards(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_forwards(campaign_id, params)
    end


    # Get unsubscribes for a campaign
    # @param [Mixed] campaign - Campaign id or Campaign object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<UnsubscribeActivity>] - Containing a results array of UnsubscribeActivity
    def get_email_campaign_unsubscribes(campaign, params = {})
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_unsubscribes(campaign_id, params)
    end


    # Get a reporting summary for a campaign
    # @param [Mixed] campaign  - Campaign id or Campaign object itself
    # @return [TrackingSummary]
    def get_email_campaign_summary_report(campaign)
      campaign_id = to_id(campaign, 'Campaign')
      Services::CampaignTrackingService.get_summary(campaign_id)
    end


    # Get sends for a Contact
    # @param [Mixed] contact - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<SendActivity>]
    def get_contact_sends(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_sends(contact_id, params)
    end


    # Get bounces for a Contact
    # @param [Mixed] contact - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<BounceActivity>]
    def get_contact_bounces(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_bounces(contact_id, params)
    end


    # Get clicks for a Contact
    # @param [Mixed] contact - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<ClickActivity>]
    def get_contact_clicks(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_clicks(contact_id, params)
    end


    # Get opens for a Contact
    # @param [Mixed] contact  - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<OpenActivity>]
    def get_contact_opens(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_opens(contact_id, params)
    end


    # Get forwards for a Contact
    # @param [Mixed] contact  - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [ResultSet<ForwardActivity>]
    def get_contact_forwards(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_forwards(contact_id, params)
    end


    # Get unsubscribes for a Contact
    # @param [Mixed] contact - Contact id or Contact object itself
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 500, default = 50.
    #     created_since - Used to retrieve a list of events since the date and time specified (in ISO-8601 format).
    #     next - the next link returned from a previous paginated call. May only be used by itself.
    # @return [UnsubscribeActivity] - Containing a results array of UnsubscribeActivity
    def get_contact_unsubscribes(contact, params = {})
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_unsubscribes(contact_id, params)
    end


    # Get a reporting summary for a Contact
    # @param [Mixed] contact - Contact id or Contact object itself
    # @return [TrackingSummary]
    def get_contact_summary_report(contact)
      contact_id = to_id(contact, 'Contact')
      Services::ContactTrackingService.get_summary(contact_id)
    end


    # Get an array of activities
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     status - Status of the activity, must be one of UNCONFIRMED, PENDING, QUEUED, RUNNING, COMPLETE, ERROR
    #     type - Type of activity, must be one of ADD_CONTACTS, REMOVE_CONTACTS_FROM_LISTS, CLEAR_CONTACTS_FROM_LISTS,
    #            EXPORT_CONTACTS
    # @return [Array<Activity>]
    def get_activities(params = {})
      Services::ActivityService.get_activities(params)
    end


    # Get a single activity by id
    # @param [String] activity_id - Activity id
    # @return [Activity]
    def get_activity(activity_id)
      Services::ActivityService.get_activity(activity_id)
    end


    # Add an AddContacts activity to add contacts in bulk
    # @param [AddContacts] add_contacts - Add Contacts Activity
    # @return [Activity]
    def add_create_contacts_activity(add_contacts)
      Services::ActivityService.create_add_contacts_activity(add_contacts)
    end


    # Create an Add Contacts Activity from a file. Valid file types are txt, csv, xls, xlsx
    # @param [String] file_name - The name of the file (ie: contacts.csv)
    # @param [String] contents - The content of the file
    # @param [String] lists - Comma separated list of ContactList id's to add the contacts to
    # @return [Activity]
    def add_create_contacts_activity_from_file(file_name, contents, lists)
      Services::ActivityService.create_add_contacts_activity_from_file(file_name, contents, lists)
    end


    # Add a ClearLists Activity to remove all contacts from the provided lists
    # @param [Array<Lists>] lists - Add Contacts Activity
    # @return [Activity]
    def add_clear_lists_activity(lists)
      Services::ActivityService.add_clear_lists_activity(lists)
    end


    # Add a Remove Contacts From Lists Activity
    # @param [Array<EmailAddress>] email_addresses - email addresses to be removed
    # @param [Array<Lists>] lists - lists to remove the provided email addresses from
    # @return [Activity]
    def add_remove_contacts_from_lists_activity(email_addresses, lists)
      Services::ActivityService.add_remove_contacts_from_lists_activity(email_addresses, lists)
    end


    # Add a Remove Contacts From Lists Activity from a file. Valid file types are txt, csv, xls, xlsx
    # @param [String] file_name - The name of the file (ie: contacts.csv)
    # @param [String] contents - The content of the file
    # @param [String] lists - Comma separated list of ContactList id' to add the contacts too
    # @return [Activity]
    def add_remove_contacts_from_lists_activity_from_file(file_name, contents, lists)
      Services::ActivityService.add_remove_contacts_from_lists_activity_from_file(file_name, contents, lists)
    end


    # Create an Export Contacts Activity
    # @param [<Array>Contacts] export_contacts - Contacts to be exported
    # @return [Activity]
    def add_export_contacts_activity(export_contacts)
      Services::ActivityService.add_export_contacts_activity(export_contacts)
    end


    # Get a list of events
    # @return [ResultSet<Event>]
    def get_events()
      Services::EventSpotService.get_events()
    end


    # Get an event
    # @param [Event] event - event id or object to be retrieved
    # @return [Event]
    def get_event(event)
      Services::EventSpotService.get_event(event)
    end


    # Create an event
    # @param [Hash] event - Event data stored in an object which respods to to_json
    # @return [Event]
    def add_event(event)
      Services::EventSpotService.add_event(event)
    end


    # Update an event
    # @param [Event|Hash] event - Event details stored in an object that responds to to_json and has an :id attribute
    # @return [Event]
    def update_event(event)
      Services::EventSpotService.update_event(event)
    end


    # Publish an event
    # @param [Event] event - Event to publish
    # @return [Event]
    def publish_event(event)
      Services::EventSpotService.publish_event(event)
    end


    # Cancel an event
    # @param [Event] event - Event to cancel
    # @return [Event]
    def cancel_event(event)
      Services::EventSpotService.cancel_event(event)
    end


    # Get a list of event fees
    # @param [Event] event - Event to get fees of
    # @return [<Array>EventFee]
    def get_event_fees(event)
      Services::EventSpotService.get_fees(event)
    end


    # Get an event fee
    # @param [Event] event - Event fee corresponds to
    # @param [EventFee] fee - Fee to retrieve
    # @return [EventFee]
    def get_event_fee(event, fee)
      Services::EventSpotService.get_fee(event, fee)
    end


    # Create an event fee
    # @param [Event] event - Event fee corresponds to
    # @param [Hash] fee - Fee details
    # @return [EventFee]
    def add_event_fee(event, fee)
      Services::EventSpotService.add_fee(event, fee)
    end


    # Update an event fee
    # @param [Event] event - Event fee corresponds to
    # @param [EventFee] fee - Fee details
    # @return [EventFee]
    def update_event_fee(event, fee)
      Services::EventSpotService.update_fee(event, fee)
    end


    # Delete an event fee
    # @param [Event] event - Event fee corresponds to
    # @param [EventFee] fee - Fee details
    # @return [Boolean]
    def delete_event_fee(event, fee)
      Services::EventSpotService.delete_fee(event, fee)
    end


    # Get a set of event registrants
    # @param [Event] event - Event fee corresponds to
    # @return [ResultSet<Registrant>]
    def get_event_registrants(event)
      Services::EventSpotService.get_registrants(event)
    end


    # Get an event registrant
    # @param [Event] event - Event registrant corresponds to
    # @param [Registrant] registrant - registrant details
    # @return [Registrant]
    def get_event_registrant(event, registrant)
      Services::EventSpotService.get_registrant(event, registrant)
    end


    # Get an array of event items for an individual event
    # @param [Integer] event_id - event id to retrieve items for
    # @return [Array<EventItem>]
    def get_event_items(event_id)
      Services::EventSpotService.get_event_items(event_id)
    end


    # Get an individual event item
    # @param [Integer] event_id - id of event to retrieve item for
    # @param [Integer] item_id - id of item to be retrieved
    # @return [EventItem]
    def get_event_item(event_id, item_id)
      Services::EventSpotService.get_event_item(event_id, item_id)
    end


    # Create a new event item for an event
    # @param [Integer] event_id - id of event to be associated with the event item
    # @param [EventItem] event_item - event item to be created
    # @return [EventItem]
    def add_event_item(event_id, event_item)
      Services::EventSpotService.add_event_item(event_id, event_item)
    end


    # Delete a specific event item for an event
    # @param [Integer] event_id - id of event to delete an event item for
    # @param [Integer] item_id - id of event item to be deleted
    # @return [Boolean]
    def delete_event_item(event_id, item_id)
      Services::EventSpotService.delete_event_item(event_id, item_id)
    end


    # Update a specific event item for an event
    # @param [Integer] event_id - id of event associated with the event item
    # @param [EventItem] event_item - event item to be updated
    # @return [EventItem]
    def update_event_item(event_id, event_item)
      Services::EventSpotService.update_event_item(event_id, event_item)
    end


    # Get an array of attributes for an individual event item
    # @param [Integer] event_id - event id to retrieve item for
    # @param [Integer] item_id - event item id to retrieve attributes for
    # @return [Array<EventItemAttribute>]
    def get_event_item_attributes(event_id, item_id)
      Services::EventSpotService.get_event_item_attributes(event_id, item_id)
    end


    # Get an individual event item attribute
    # @param [Integer] event_id - id of event to retrieve item for
    # @param [Integer] item_id - id of item to retrieve attribute for
    # @param [Integer] attribute_id - id of attribute to be retrieved
    # @return [EventItemAttribute]
    def get_event_item_attribute(event_id, item_id, attribute_id)
      Services::EventSpotService.get_event_item_attribute(event_id, item_id, attribute_id)
    end


    # Create a new event item attribute for an event item
    # @param [Integer] event_id - id of event to be associated with the event item attribute
    # @param [Integer] item_id - id of event item to be associated with the event item attribute
    # @param [EventItemAttribute] event_item_attribute - event item attribute to be created
    # @return [EventItemAttribute]
    def add_event_item_attribute(event_id, item_id, event_item_attribute)
      Services::EventSpotService.add_event_item_attribute(event_id, item_id, event_item_attribute)
    end


    # Delete a specific event item for an event
    # @param [Integer] event_id - id of event to delete an event item attribute for
    # @param [Integer] item_id - id of event item to delete an event item attribute for
    # @param [Integer] attribute_id - id of attribute to be deleted
    # @return [Boolean]
    def delete_event_item_attribute(event_id, item_id, attribute_id)
      Services::EventSpotService.delete_event_item_attribute(event_id, item_id, attribute_id)
    end


    # Update a specific event item attribute for an event item
    # @param [Integer] event_id - id of event associated with the event item
    # @param [Integer] item_id - id of event item associated with the event item attribute
    # @param [EventItemAttribute] event_item_attribute - event item to be updated
    # @return [EventItemAttribute]
    def update_event_item_attribute(event_id, item_id, event_item_attribute)
      Services::EventSpotService.update_event_item_attribute(event_id, item_id, event_item_attribute)
    end


    # Get an array of promocodes for an individual event
    # @param [Integer] event_id - event id to retrieve promocodes for
    # @return [Array<Promocode>]
    def get_promocodes(event_id)
      Services::EventSpotService.get_promocodes(event_id)
    end


    # Get an individual promocode
    # @param [Integer] event_id - id of event to retrieve item for
    # @param [Integer] promocode_id - id of item to be retrieved
    # @return [Promocode]
    def get_promocode(event_id, promocode_id)
      Services::EventSpotService.get_promocode(event_id, promocode_id)
    end


    # Create a new promocode for an event
    # @param [Integer] event_id - id of event to be associated with the promocode
    # @param [Promocode] promocode - promocode to be created
    # @return [Promocode]
    def add_promocode(event_id, promocode)
      Services::EventSpotService.add_promocode(event_id, promocode)
    end


    # Delete a specific promocode for an event
    # @param [Integer] event_id - id of event to delete a promocode for
    # @param [Integer] promocode_id - id of promocode to be deleted
    # @return [Boolean]
    def delete_promocode(event_id, promocode_id)
      Services::EventSpotService.delete_promocode(event_id, promocode_id)
    end


    # Update a specific promocode for an event
    # @param [Integer] event_id - id of event associated with the promocode
    # @param [Promocode] promocode - promocode to be updated
    # @return [Promocode]
    def update_promocode(event_id, promocode)
      Services::EventSpotService.update_promocode(event_id, promocode)
    end


    # Retrieve MyLibrary usage information
    # @return [LibrarySummary]
    def get_library_info()
      Services::LibraryService.get_library_info()
    end


    # Retrieve a list of MyLibrary folders
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     sort_by - The method to sort by, valid values are :
    #         CREATED_DATE - sorts by date folder was added, ascending (earliest to latest)
    #         CREATED_DATE_DESC - (default) sorts by date folder was added, descending (latest to earliest)
    #         MODIFIED_DATE - sorts by date folder was last modified, ascending (earliest to latest)
    #         MODIFIED_DATE_DESC - sorts by date folder was last modified, descending (latest to earliest)
    #         NAME - sorts alphabetically by folder name, a to z
    #         NAME_DESC - sorts alphabetically by folder name, z to a
    #     limit -  Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
    # @return [ResultSet<LibraryFolder>]
    def get_library_folders(params = {})
      Services::LibraryService.get_library_folders(params)
    end


    # Create a new MyLibrary folder
    # @param [LibraryFolder] folder - Library Folder to be created
    # @return [LibraryFolder]
    def add_library_folder(folder)
      Services::LibraryService.add_library_folder(folder)
    end


    # Retrieve a specific MyLibrary folder using the folder_id path parameter
    # @param [String] folder_id - The ID for the folder to return
    # @return [LibraryFolder]
    def get_library_folder(folder_id)
      Services::LibraryService.get_library_folder(folder_id)
    end


    # Update a specific MyLibrary folder
    # @param [LibraryFolder] folder - MyLibrary folder to be updated
    # @return [LibraryFolder]
    def update_library_folder(folder)
      Services::LibraryService.update_library_folder(folder)
    end


    # Delete a MyLibrary folder
    # @param [String] folder_id - The ID for the MyLibrary folder to delete
    # @return [Boolean]
    def delete_library_folder(folder_id)
      Services::LibraryService.delete_library_folder(folder_id)
    end


    # Retrieve all files in the Trash folder
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     type - Specifies the type of files to retrieve, valid values are : ALL, IMAGES, or DOCUMENTS
    #     sort_by - The method to sort by, valid values are :
    #         ADDED_DATE - sorts by date folder was added, ascending (earliest to latest)
    #         ADDED_DATE_DESC - (default) sorts by date folder was added, descending (latest to earliest)
    #         MODIFIED_DATE - sorts by date folder was last modified, ascending (earliest to latest)
    #         MODIFIED_DATE_DESC - sorts by date folder was last modified, descending (latest to earliest)
    #         NAME - sorts alphabetically by file name, a to z
    #         NAME_DESC - sorts alphabetically by file name, z to a
    #         SIZE - sorts by file size, smallest to largest
    #         SIZE_DESC - sorts by file size, largest to smallest
    #         DIMENSION - sorts by file dimensions (hxw), smallest to largest
    #         DIMENSION_DESC - sorts by file dimensions (hxw), largest to smallest
    #     limit -  Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
    # @return [ResultSet<LibraryFile>]
    def get_library_trash(params = {})
      Services::LibraryService.get_library_trash(params)
    end


    # Permanently deletes all files in the Trash folder
    # @return [Boolean]
    def delete_library_trash()
      Services::LibraryService.delete_library_trash()
    end


    # Retrieve a collection of Library files in the Constant Contact account
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     type - Specifies the type of files to retrieve, valid values are : ALL, IMAGES, or DOCUMENTS
    #     source - Specifies to retrieve files from a particular source, valid values are :
    #         ALL - (default) files from all sources
    #         MyComputer
    #         StockImage
    #         Facebook
    #         Instagram
    #         Shutterstock
    #         Mobile
    #     limit -  Specifies the number of results displayed per page of output, from 1 - 1000, default = 50.
    # @return [ResultSet<LibraryFile>]
    def get_library_files(params = {})
      Services::LibraryService.get_library_files(params)
    end


    # Retrieves all files from a MyLibrary folder specified by the folder_id path parameter
    # @param [String] folder_id  - Specifies the folder from which to retrieve files
    # @param [Hash] params - hash of query parameters and values to append to the request.
    #     Allowed parameters include:
    #     limit - Specifies the number of results displayed per page of output, from 1 - 50, default = 50.
    # @return [ResultSet<LibraryFile>]
    def get_library_files_by_folder(folder_id, params = {})
      Services::LibraryService.get_library_files_by_folder(folder_id, params)
    end


    # Retrieve a MyLibrary file using the file_id path parameter
    # @param [String] file_id - Specifies the MyLibrary file for which to retrieve information
    # @return [LibraryFile]
    def get_library_file(file_id)
      Services::LibraryService.get_library_file(file_id)
    end


    # Adds a new MyLibrary file using the multipart content-type
    # @param [String] file_name - The name of the file (ie: dinnerplate-special.jpg)
    # @param [String] folder_id - Folder id to add the file to
    # @param [String] description - The description of the file provided by user 
    # @param [String] source - indicates the source of the original file; 
    #                          image files can be uploaded from the following sources :
    #                          MyComputer, StockImage, Facebook - MyLibrary Plus customers only,
    #                          Instagram - MyLibrary Plus customers only, Shutterstock, Mobile
    # @param [String] file_type - Specifies the file type, valid values are: JPEG, JPG, GIF, PDF, PNG 
    # @param [String] contents - The content of the file
    # @return [LibraryFile]
    def add_library_file(file_name, folder_id, description, source, file_type, contents)
      Services::LibraryService.add_library_file(file_name, folder_id, description, source, file_type, contents)
    end


    # Update information for a specific MyLibrary file
    # @param [LibraryFile] file - Library File to be updated
    # @return [LibraryFile]
    def update_library_file(file)
      Services::LibraryService.update_library_file(file)
    end


    # Delete one or more MyLibrary files specified by the fileId path parameter;
    # separate multiple file IDs with a comma. 
    # Deleted files are moved from their current folder into the system Trash folder, and its status is set to Deleted.
    # @param [String] file_id - Specifies the MyLibrary file to delete
    # @return [Boolean]
    def delete_library_file(file_id)
      Services::LibraryService.delete_library_file(file_id)
    end


    # Retrieve the upload status for one or more MyLibrary files using the file_id path parameter; 
    # separate multiple file IDs with a comma
    # @param [String] file_id - Specifies the files for which to retrieve upload status information
    # @return [Array<UploadStatus>]
    def get_library_files_upload_status(file_id)
      Services::LibraryService.get_library_files_upload_status(file_id)
    end


    # Move one or more MyLibrary files to a different folder in the user's account
    # specify the destination folder using the folder_id path parameter.
    # @param [String] folder_id - Specifies the destination MyLibrary folder to which the files will be moved
    # @param [String] file_id - Specifies the files to move, in a string of comma separated file ids (e.g. 8,9)
    # @return [Array<MoveResults>]
    def move_library_files(folder_id, file_id)
      Services::LibraryService.move_library_files(folder_id, file_id)
    end



    private


    # Get the id of object, or attempt to convert the argument to an int
    # @param [Mixed] item - object or a numeric value
    # @param [String] class_name - class name to test the given object against
    # @raise IllegalArgumentException - if the item is not an instance of the class name given, or cannot be
    # converted to a numeric value
    # @return [Integer]
    def to_id(item, class_name)
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
