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
        # @param [Hash] params - query parameters to be appended to the request
        # @return [Array<ContactList>]
        def get_lists(params = {})
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.lists')
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          lists = []
          JSON.parse(response.body).each do |contact|
            lists << Components::ContactList.create(contact)
          end
          lists
        end


        # Add a new list to the Constant Contact account
        # @param [ContactList] list
        # @return [ContactList]
        def add_list(list)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.lists')
          url = build_url(url)
          payload = list.to_json
          response = RestClient.post(url, payload, get_headers())
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Update a Contact List
        # @param [ContactList] list - ContactList to be updated
        # @return [ContactList]
        def update_list(list)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list'), list.id)
          url = build_url(url)
          payload = list.to_json
          response = RestClient.put(url, payload, get_headers())
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Get an individual contact list
        # @param [Integer] list_id - list id
        # @return [ContactList]
        def get_list(list_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list'), list_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers())
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Get all contacts from an individual list
        # @param [Integer] list_id - list id to retrieve contacts for
        # @param [Hash] params - query parameters to attach to request
        # @return [Array<Contact>]
        def get_contacts_from_list(list_id, params = nil)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list_contacts'), list_id)
          url = build_url(url, params)
          response = RestClient.get(url, get_headers())
          contacts = []
          body = JSON.parse(response.body)
          body['results'].each do |contact|
            contacts << Components::Contact.create(contact)
          end
          Components::ResultSet.new(contacts, body['meta'])
        end

      end
    end
  end
end