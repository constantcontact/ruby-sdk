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
        # @param [Hash] param - query parameters to be appended to the request
        # @return [ResultSet<Contact>]
        def get_contacts(access_token, param = nil)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts')
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          contacts = []
          body['results'].each do |contact|
            contacts << Components::Contact.create(contact)
          end

          Components::ResultSet.new(contacts, body['meta'])
        end


        # Get contact details for a specific contact
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] contact_id - Unique contact id
        # @return [Contact]
        def get_contact(access_token, contact_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.contact'), contact_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::Contact.create(JSON.parse(response.body))
        end


        # Add a new contact to the Constant Contact account
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Contact] contact - Contact to add
        # @param [Boolean] action_by_visitor - is the action being taken by the visitor
        # @return [Contact]
        def add_contact(access_token, contact, action_by_visitor = false)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts')
          param = action_by_visitor ? {'action_by' => 'ACTION_BY_VISITOR'} : nil
          url = build_url(url, param)
          payload = contact.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::Contact.create(JSON.parse(response.body))
        end


        # Delete contact details for a specific contact
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] contact_id - Unique contact id
        # @return [Boolean]
        def delete_contact(access_token, contact_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Delete a contact from all contact lists
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] contact_id - Contact id to be removed from lists
        # @return [Boolean]
        def delete_contact_from_lists(access_token, contact_id)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact_lists'), contact_id)
          url = build_url(url)
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
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update contact details for a specific contact
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Contact] contact - Contact to be updated
        # @param [Boolean] action_by_visitor - is the action being taken by the visitor
        # @return [Contact]
        def update_contact(access_token, contact, action_by_visitor = false)
          url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact.id)
          param = action_by_visitor ? {'action_by' => 'ACTION_BY_VISITOR'} : nil
          url = build_url(url, param)
          payload = contact.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::Contact.create(JSON.parse(response.body))
        end

      end
    end
  end
end