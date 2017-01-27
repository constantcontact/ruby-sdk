#
# email_marketing_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class EmailMarketingService < BaseService

      # Create a new campaign
      # @param [Campaign] campaign - Campaign to be created
      # @return [Campaign]
      def add_campaign(campaign)
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.campaigns')
        url = build_url(url)
        payload = campaign.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Campaign.create(JSON.parse(response.body))
      end


      # Get a set of campaigns
      # @param [Hash] params - query parameters to be appended to the request
      # @return [ResultSet<Campaign>]
      def get_campaigns(params = {})
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.campaigns')
        url = build_url(url, params)

        response = RestClient.get(url, get_headers())
        body = JSON.parse(response.body)

        campaigns = []
        body['results'].each do |campaign|
          campaigns << Components::Campaign.create_summary(campaign)
        end

        Components::ResultSet.new(campaigns, body['meta'])
      end


      # Get campaign details for a specific campaign
      # @param [Integer] campaign_id - Valid campaign id
      # @return [Campaign]
      def get_campaign(campaign_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign'), campaign_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::Campaign.create(JSON.parse(response.body))
      end


      # Get the preview of the given campaign
      # @param [Integer] campaign_id - Valid campaign id
      # @return [CampaignPreview]
      def get_campaign_preview(campaign_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_preview'), campaign_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::CampaignPreview.create(JSON.parse(response.body))
      end


      # Delete an email campaign
      # @param [Integer] campaign_id - Valid campaign id
      # @return [Boolean]
      def delete_campaign(campaign_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign'), campaign_id)
        url = build_url(url)
        response = RestClient.delete(url, get_headers())
        response.code == 204
      end


      # Update a specific email campaign
      # @param [Campaign] campaign - Campaign to be updated
      # @return [Campaign]
      def update_campaign(campaign)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign'), campaign.id)
        url = build_url(url)
        payload = campaign.to_json
        response = RestClient.put(url, payload, get_headers())
        Components::Campaign.create(JSON.parse(response.body))
      end

    end
  end
end