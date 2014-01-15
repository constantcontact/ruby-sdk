#
# email_marketing_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class EmailMarketingService < BaseService
      class << self

        # Create a new campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Campaign] campaign - Campaign to be created
        # @return [Campaign]
        def add_campaign(access_token, campaign)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.campaigns')
          url = build_url(url)
          payload = campaign.to_json
          response = RestClient.post(url, payload, get_headers(access_token))
          Components::Campaign.create(JSON.parse(response.body))
        end


        # Get a set of campaigns
        # @param [String] access_token Constant Contact OAuth2 access token
        # @param [Hash] params - query parameters to be appended to the request
        # @return [ResultSet<Campaign>]
        def get_campaigns(access_token, params = {})
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.campaigns')
          url = build_url(url, params)

          response = RestClient.get(url, get_headers(access_token))
          body = JSON.parse(response.body)

          campaigns = []
          body['results'].each do |campaign|
            campaigns << Components::Campaign.create_summary(campaign)
          end

          Components::ResultSet.new(campaigns, body['meta'])
        end


        # Get campaign details for a specific campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] campaign_id - Valid campaign id
        # @return [Campaign]
        def get_campaign(access_token, campaign_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign'), campaign_id)
          url = build_url(url)
          response = RestClient.get(url, get_headers(access_token))
          Components::Campaign.create(JSON.parse(response.body))
        end


        # Delete an email campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Integer] campaign_id - Valid campaign id
        # @return [Boolean]
        def delete_campaign(access_token, campaign_id)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign'), campaign_id)
          url = build_url(url)
          response = RestClient.delete(url, get_headers(access_token))
          response.code == 204
        end


        # Update a specific email campaign
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Campaign] campaign - Campaign to be updated
        # @return [Campaign]
        def update_campaign(access_token, campaign)
          url = Util::Config.get('endpoints.base_url') +
                sprintf(Util::Config.get('endpoints.campaign'), campaign.id)
          url = build_url(url)
          payload = campaign.to_json
          response = RestClient.put(url, payload, get_headers(access_token))
          Components::Campaign.create(JSON.parse(response.body))
        end

      end
    end
  end
end