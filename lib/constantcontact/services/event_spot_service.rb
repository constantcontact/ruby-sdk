#
# event_spot_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class EventSpotService < BaseService
      class << self

        # Create a new event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Event] event - Event to be created
        # @return [Event]
        def add_event(access_token, event)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.events')
          url = build_url(url)
          payload = event.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Get a set of events
        # @param [String] access_token Constant Contact OAuth2 access token
        # @param [Hash] opts query parameters to be appended to the request
        # @option opts [String] status email campaigns status of DRAFT, RUNNING, SENT, SCHEDULED.
        # @option opts [String] modified_since ISO-8601 date string to return campaigns modified since then.
        # @option opts [Integer] limit number of campaigns to return, 1 to 50.
        # @return [ResultSet<Event>]
        def get_events(access_token, opts = {})
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.events')
          url = build_url(url, opts)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          events = body['results'].collect do |event|
            Components::Event.create_summary(event)
          end

          Components::ResultSet.new(events, body['meta'])
        end


        # Get event details for a specific event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @return [Event]
        def get_event(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event'), event_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Delete an EventSpot event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @return [Boolean]
        def delete_event(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event'), event_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update a specific EventSpot event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Event] event - Event to be updated
        # @return [Event]
        def update_event(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event'), event_id)
          url = build_url(url)
          payload = event.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Publish a specific EventSpot event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Event] event - Event to be updated
        # @return [Event]
        def publish_event(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event'), event_id)
          url = build_url(url)
          payload = [{:op => "REPLACE", :path => "#/status", :value => "ACTIVE"}].to_json
          response = RestClient.patch(url, payload, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Cancel a specific EventSpot event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Event] event - Event to be updated
        # @return [Event]
        def cancel_event(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event'), event_id)
          url = build_url(url)
          payload = [{ :op => "REPLACE", :path => "#/status", :value => "CANCELLED" }].to_json
          response = RestClient.patch(url, payload, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Create a new event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [EventFee] fee - Event fee to be created
        # @return [EventFee]
        def add_fee(access_token, event, fee)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fees'), event_id)
          url = build_url(url)
          payload = fee.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::EventFee.create(JSON.parse(response.body))
        end


        # Get an array of event fees
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @return [Array<EventFee>]
        def get_fees(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fees'), event_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)
          
          fees = body.collect do |fee|
            Components::EventFee.create(fee)
          end
        end


        # Get an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [EventFee]
        def get_fee(access_token, event, fee)
          event_id  = get_id_for(event)
          fee_id    = get_id_for(fee)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fee'), event_id, fee_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
         fee = Components::EventFee.create(JSON.parse(response.body))
        end


        # Update an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [EventFee]
        def update_fee(access_token, event, fee)
          event_id  = get_id_for(event)
          if fee.kind_of?(ConstantContact::Components::EventFee)
            fee_id = fee.id
          elsif fee.kind_of?(Hash)
            fee_id = fee['id']
          else
            raise ArgumentError.new "Fee must be a Hash or ConstantContact::Components::Fee"
          end

          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fee'), event_id, fee_id)
          url = build_url(url)
          payload = fee.to_json

          response = RestClient.put(url, payload, get_headers(access_token))
         fee = Components::EventFee.create(JSON.parse(response.body))
        end


        # Delete an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [Boolean]
        def delete_fee(access_token, event, fee)
          event_id  = get_id_for(event)
          fee_id    = get_id_for(fee)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fee'), event_id, fee_id)
          url = build_url(url)

          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Get a set of event registrants
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @return [ResultSet<Registrant>]
        def get_registrants(access_token, event)
          event_id  = event.kind_of?(ConstantContact::Components::Event) ? event.id : event
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_registrants'), event_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          registrants = body['results'].collect do |registrant|
            Components::Registrant.create(registrant)
          end

          Components::ResultSet.new(registrants, body['meta'])
        end


        # Get an individual event registant
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] registrant - Valid fee id
        # @return [Registrant]
        def get_registrant(access_token, event, registrant)
          event_id      = get_id_for(event)
          registrant_id  = get_id_for(registrant)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_registrant'), event_id, registrant_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
          Components::Registrant.create(JSON.parse(response.body))
        end


        # Get an array of event items for an individual event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - event id to retrieve items for
        # @return [Array<EventItem>]
        def get_event_items(access_token, event_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_items'), event_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))

          event_items = []
          JSON.parse(response.body).each do |event_item|
            event_items << Components::EventItem.create(event_item)
          end

          event_items
        end


        # Get an individual event item
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to retrieve item for
        # @param [Integer] item_id - id of item to be retrieved
        # @return [EventItem]
        def get_event_item(access_token, event_id, item_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_item'), event_id, item_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::EventItem.create(JSON.parse(response.body))
        end


        # Create a new event item for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to be associated with the event item
        # @param [EventItem] event_item - event item to be created
        # @return [EventItem]
        def add_event_item(access_token, event_id, event_item)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_items'), event_id)
          url = build_url(url)
          payload = event_item.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::EventItem.create(JSON.parse(response.body))
        end


        # Delete a specific event item for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to delete an event item for
        # @param [Integer] item_id - id of event item to be deleted
        # @return [Boolean]
        def delete_event_item(access_token, event_id, item_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_item'), event_id, item_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update a specific event item for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event associated with the event item
        # @param [EventItem] event_item - event item to be updated
        # @return [EventItem]
        def update_event_item(access_token, event_id, event_item)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_item'), event_id, event_item.id)
          url = build_url(url)
          payload = event_item.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::EventItem.create(JSON.parse(response.body))
        end


        # Get an array of attributes for an individual event item
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - event id to retrieve item for
        # @param [Integer] item_id - event item id to retrieve attributes for
        # @return [Array<EventItemAttribute>]
        def get_event_item_attributes(access_token, event_id, item_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_item_attributes'), event_id, item_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))

          event_item_attributes = []
          JSON.parse(response.body).each do |event_item_attribute|
            event_item_attributes << Components::EventItemAttribute.create(event_item_attribute)
          end

          event_item_attributes
        end


        # Get an individual event item attribute
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to retrieve item for
        # @param [Integer] item_id - id of item to retrieve attribute for
        # @param [Integer] attribute_id - id of attribute to be retrieved
        # @return [EventItemAttribute]
        def get_event_item_attribute(access_token, event_id, item_id, attribute_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_item_attribute'), event_id, item_id, attribute_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::EventItemAttribute.create(JSON.parse(response.body))
        end


        # Create a new event item attribute for an event item
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to be associated with the event item attribute
        # @param [Integer] item_id - id of event item to be associated with the event item attribute
        # @param [EventItemAttribute] event_item_attribute - event item attribute to be created
        # @return [EventItemAttribute]
        def add_event_item_attribute(access_token, event_id, item_id, event_item_attribute)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_item_attributes'), event_id, item_id)
          url = build_url(url)
          payload = event_item_attribute.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::EventItemAttribute.create(JSON.parse(response.body))
        end


        # Delete a specific event item for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to delete an event item attribute for
        # @param [Integer] item_id - id of event item to delete an event item attribute for
        # @param [Integer] attribute_id - id of attribute to be deleted
        # @return [Boolean]
        def delete_event_item_attribute(access_token, event_id, item_id, attribute_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_item_attribute'), event_id, item_id, attribute_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update a specific event item attribute for an event item
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event associated with the event item
        # @param [Integer] item_id - id of event item associated with the event item attribute
        # @param [EventItemAttribute] event_item_attribute - event item to be updated
        # @return [EventItemAttribute]
        def update_event_item_attribute(access_token, event_id, item_id, event_item_attribute)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_item'), event_id, item_id, event_item_attribute.id)
          url = build_url(url)
          payload = event_item_attribute.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::EventItemAttribute.create(JSON.parse(response.body))
        end


        # Get an array of promocodes for an individual event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - event id to retrieve promocodes for
        # @return [Array<Promocode>]
        def get_promocodes(access_token, event_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_promocodes'), event_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))

          promocodes = []
          JSON.parse(response.body).each do |promocode|
            promocodes << Components::Promocode.create(promocode)
          end

          promocodes
        end


        # Get an individual promocode
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to retrieve item for
        # @param [Integer] promocode_id - id of item to be retrieved
        # @return [Promocode]
        def get_promocode(access_token, event_id, promocode_id)
          url = Util::Config.get('endpoints.base_url') + 
                sprintf(Util::Config.get('endpoints.event_promocode'), event_id, promocode_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::Promocode.create(JSON.parse(response.body))
        end


        # Create a new promocode for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to be associated with the promocode
        # @param [Promocode] promocode - promocode to be created
        # @return [Promocode]
        def add_promocode(access_token, event_id, promocode)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_promocodes'), event_id)
          url = build_url(url)
          payload = promocode.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::Promocode.create(JSON.parse(response.body))
        end


        # Delete a specific promocode for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event to delete a promocode for
        # @param [Integer] promocode_id - id of promocode to be deleted
        # @return [Boolean]
        def delete_promocode(access_token, event_id, promocode_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_promocode'), event_id, promocode_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update a specific promocode for an event
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event_id - id of event associated with the promocode
        # @param [Promocode] promocode - promocode to be updated
        # @return [Promocode]
        def update_promocode(access_token, event_id, promocode)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_promocode'), event_id, promocode.id)
          url = build_url(url)
          payload = promocode.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::Promocode.create(JSON.parse(response.body))
        end


      end
    end
  end
end