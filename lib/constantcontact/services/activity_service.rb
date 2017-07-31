#
# activity_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class ActivityService < BaseService

      # Get a set of activities
      # @param [Hash] params - query parameters to be appended to the url
      # @return [Array<Activity>]
      def get_activities(params = {})
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.activities')
        url = build_url(url, params)
        response = RestClient.get(url, get_headers())

        activities = []
        JSON.parse(response.body).each do |activity|
          activities << Components::Activity.create(activity)
        end

        activities
      end


      # Get an array of activities
      # @param [String] activity_id - Activity id
      # @return [Activity]
      def get_activity(activity_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.activity'), activity_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create an Add Contacts Activity
      # @param [AddContacts] add_contacts
      # @return [Activity]
      def create_add_contacts_activity(add_contacts)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.add_contacts_activity')
        url = build_url(url)
        payload = add_contacts.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create an Add Contacts Activity from a file. Valid file types are txt, csv, xls, xlsx
      # @param [String] file_name - The name of the file (ie: contacts.csv)
      # @param [String] contents - The content of the file
      # @param [String] lists - Comma separated list of ContactList id's to add the contacts to
      # @return [Activity]
      def create_add_contacts_activity_from_file(file_name, contents, lists)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.add_contacts_activity')
        url = build_url(url)

        payload = { :file_name => file_name, :lists => lists, :data => contents, :multipart => true }

        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create a Clear Lists Activity
      # @param [Array<lists>] lists - array of list id's to be cleared
      # @return [Activity]
      def add_clear_lists_activity(lists)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.clear_lists_activity')
        url = build_url(url)
        payload = {'lists' => lists}.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create an Export Contacts Activity
      # @param [ExportContacts] export_contacts
      # @return [Activity]
      def add_export_contacts_activity(export_contacts)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.export_contacts_activity')
        url = build_url(url)
        payload = export_contacts.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create a Remove Contacts From Lists Activity
      # @param [<Array>EmailAddress] email_addresses
      # @param [<Array>RemoveFromLists] lists
      # @return [Activity]
      def add_remove_contacts_from_lists_activity(email_addresses, lists)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.remove_from_lists_activity')
        url = build_url(url)

        payload = { 'import_data' => [], 'lists' => lists }
        email_addresses.each do |email_address|
          payload['import_data'] << { 'email_addresses' => [email_address] }
        end
        payload = payload.to_json

        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end


      # Create an Remove Contacts Activity from a file. Valid file types are txt, csv, xls, xlsx
      # @param [String] file_name - The name of the file (ie: contacts.csv)
      # @param [String] contents - The content of the file
      # @param [String] lists - Comma separated list of ContactList id' to add the contacts too
      # @return [Activity]
      def add_remove_contacts_from_lists_activity_from_file(file_name, contents, lists)
        url = Util::Config.get('endpoints.base_url') +
              Util::Config.get('endpoints.remove_from_lists_activity')
        url = build_url(url)

        payload = { :file_name => file_name, :lists => lists, :data => contents, :multipart => true }

        response = RestClient.post(url, payload, get_headers())
        Components::Activity.create(JSON.parse(response.body))
      end

    end
  end
end