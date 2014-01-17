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
          payload = [{op: "REPLACE", path: "#/status", value: "ACTIVE"}].to_json
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
          payload = [{op: "REPLACE", path: "#/status", value: "CANCELLED"}].to_json
          response = RestClient.patch(url, payload, get_headers(access_token))
          Components::Event.create(JSON.parse(response.body))
        end


        # Create a new event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Fee] fee - Event fee to be created
        # @return [Fee]
        def add_fee(access_token, event, fee)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fees'), event_id)
          url = build_url(url)
          payload = fee.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::Fee.create(JSON.parse(response.body))
        end


        # Get a set of event fees
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @return [ResultSet<Fee>]
        def get_fees(access_token, event)
          event_id = get_id_for(event)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fees'), event_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)
          
          fees = body.collect do |fee|
            Components::Fee.create(fee)
          end
        end


        # Get an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [Fee]
        def get_fee(access_token, event, fee)
          event_id  = get_id_for(event)
          fee_id    = get_id_for(fee)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fee'), event_id, fee_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
         fee = Components::Fee.create(JSON.parse(response.body))
        end


        # Update an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [Fee]
        def update_fee(access_token, event, fee)
          event_id  = get_id_for(event)
          if fee.kind_of?(ConstantContact::Components::Fee)
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
         fee = Components::Fee.create(JSON.parse(response.body))
        end


        # Delete an individual event fee
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] event - Valid event id
        # @param [Integer] fee - Valid fee id
        # @return [Fee]
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
        # @return [Fee]
        def get_registrant(access_token, event, registrant)
          event_id      = get_id_for(event)
          registrant_id  = get_id_for(registrant)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.event_fee'), event_id, registrant_id)
          url = build_url(url)

          response = RestClient.get(url, get_headers(access_token))
         registrant = Components::Registrant.create(JSON.parse(response.body))
        end

      end
    end
  end
end