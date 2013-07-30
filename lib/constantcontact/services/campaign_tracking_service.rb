#
# campaign_tracking_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class CampaignTrackingService < BaseService
      class << self

        # Get a result set of bounces for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query parameters to be appended to request
        # @return [ResultSet<BounceActivity>] - Containing a results array of BounceActivity
        def get_bounces(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_bounces'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          bounces = []
          body['results'].each do |bounce_activity|
            bounces << Components::BounceActivity.create(bounce_activity)
          end

          Components::ResultSet.new(bounces, body['meta'])
        end


        # Get clicks for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query parameters to be appended to request
        # @return [ResultSet<ClickActivity>] - Containing a results array of ClickActivity
        def get_clicks(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_clicks'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          clicks = []
          body['results'].each do |click_activity|
            clicks << Components::ClickActivity.create(click_activity)
          end

          Components::ResultSet.new(clicks, body['meta'])
        end


        # Get forwards for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query parameters to be appended to request
        # @return [ResultSet<ForwardActivity>] - Containing a results array of ForwardActivity
        def get_forwards(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_forwards'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          forwards = []
          body['results'].each do |forward_activity|
            forwards << Components::ForwardActivity.create(forward_activity)
          end

          Components::ResultSet.new(forwards, body['meta'])
        end


        # Get opens for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query parameters to be appended to request
        # @return [ResultSet<OpenActivity>] - Containing a results array of OpenActivity
        def get_opens(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_opens'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          opens = []
          body['results'].each do |open_activity|
            opens << Components::OpenActivity.create(open_activity)
          end

          Components::ResultSet.new(opens, body['meta'])
        end


        # Get sends for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query parameters to be appended to request
        # @return [ResultSet<SendActivity>] - Containing a results array of SendActivity
        def get_sends(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_sends'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          sends = []
          body['results'].each do |send_activity|
            sends << Components::SendActivity.create(send_activity)
          end

          Components::ResultSet.new(sends, body['meta'])
        end


        # Get unsubscribes for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [String] campaign_id - Campaign id
        # @param [Hash] param - query params to be appended to request
        # @return [ResultSet<UnsubscribeActivity>] - Containing a results array of UnsubscribeActivity
        def get_unsubscribes(access_token, campaign_id, param = nil)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_unsubscribes'), campaign_id)
          url = build_url(url, param)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          unsubscribes = []
          body['results'].each do |unsubscribe_activity|
            unsubscribes[] = Components::UnsubscribeActivity.create(unsubscribe_activity)
          end

          Components::ResultSet.new(unsubscribes, body['meta'])
        end


        # Get a summary of reporting data for a given campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] campaign_id - Campaign id
        # @return [TrackingSummary]
        def get_summary(access_token, campaign_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign_tracking_summary'), campaign_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::TrackingSummary.create(JSON.parse(response.body))
        end

      end
    end
  end
end