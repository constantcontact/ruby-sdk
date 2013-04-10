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
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          lists = []
          JSON.parse(response.body).each do |contact|
            lists << Components::ContactList.create(contact)
          end
          lists
        end


        # Add a new list to the Constant Contact account
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [ContactList] list
        # @return [ContactList]
        def add_list(access_token, list)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.lists')
          url = build_url(url)
          payload = list.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Update a Contact List
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [ContactList] list - ContactList to be updated
        # @return [ContactList]
        def update_list(access_token, list)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list'), list.id)
          url = build_url(url)
          payload = list.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Get an individual contact list
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] list_id - list id
        # @return [ContactList]
        def get_list(access_token, list_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list'), list_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::ContactList.create(JSON.parse(response.body))
        end


        # Get all contacts from an individual list
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] list_id - list id to retrieve contacts for
        # @param [Hash] param - query parameters to attach to request
        # @return [Array<Contact>]
        def get_contacts_from_list(access_token, list_id, param = nil)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.list_contacts'), list_id)
          url = build_url(url, param)
          response = RestClient.get(url, get_headers(access_token))
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