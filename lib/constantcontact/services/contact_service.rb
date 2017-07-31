#
# contact_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class ContactService < BaseService

      # Get an array of contacts
      # @param [Hash] params - query parameters to be appended to the request
      # @return [ResultSet<Contact>]
      def get_contacts(params = {})
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts')
        url = build_url(url, params)

        response = RestClient.get(url, get_headers())
        body = JSON.parse(response.body)

        contacts = []
        body['results'].each do |contact|
          contacts << Components::Contact.create(contact)
        end

        Components::ResultSet.new(contacts, body['meta'])
      end


      # Get contact details for a specific contact
      # @param [Integer] contact_id - Unique contact id
      # @return [Contact]
      def get_contact(contact_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.contact'), contact_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::Contact.create(JSON.parse(response.body))
      end


      # Add a new contact to the Constant Contact account
      # @param [Contact] contact - Contact to add
      # @param [Boolean] params - query params to be appended to the request
      # @return [Contact]
      def add_contact(contact, params = {})
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.contacts')
        url = build_url(url, params)
        payload = contact.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Contact.create(JSON.parse(response.body))
      end


      # Delete contact details for a specific contact
      # @param [Integer] contact_id - Unique contact id
      # @return [Boolean]
      def delete_contact(contact_id)
        url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact_id)
        url = build_url(url)
        response = RestClient.delete(url, get_headers())
        response.code == 204
      end


      # Delete a contact from all contact lists
      # @param [Integer] contact_id - Contact id to be removed from lists
      # @return [Boolean]
      def delete_contact_from_lists(contact_id)
        url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact_lists'), contact_id)
        url = build_url(url)
        response = RestClient.delete(url, get_headers())
        response.code == 204
      end


      # Delete a contact from a specific contact list
      # @param [Integer] contact_id - Contact id to be removed
      # @param [Integer] list_id - ContactList id to remove the contact from
      # @return [Boolean]
      def delete_contact_from_list(contact_id, list_id)
        url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact_list'), contact_id, list_id)
        url = build_url(url)
        response = RestClient.delete(url, get_headers())
        response.code == 204
      end


      # Update contact details for a specific contact
      # @param [Contact] contact - Contact to be updated
      # @param [Hash] params - query params to be appended to the request
      # @return [Contact]
      def update_contact(contact, params = {})
        url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.contact'), contact.id)
        url = build_url(url, params)
        payload = contact.to_json
        response = RestClient.put(url, payload, get_headers())
        Components::Contact.create(JSON.parse(response.body))
      end

    end
  end
end