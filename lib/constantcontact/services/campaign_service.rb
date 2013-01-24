#
# campaign_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class CampaignService < BaseService
			class << self

				# Get a set of campaigns
				# @param [String] access_token
				# @param [Integer] offset - denotes the starting number for the result set
				# @param [Integer] limit - denotes the number of results per set of results, limited to 50
				# @return [Array<Campaign>]
				def get_campaigns(access_token, offset = nil, limit = nil )
					url = paginate_url(
						Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.campaigns'), offset, limit
					)

					response = RestClient.get(url, get_headers(access_token))

					campaigns = []
					JSON.parse(response.body).each do |contact|
						campaigns << Components::Campaign.from_array(contact)
					end
					campaigns
				end


				# Get campaign details for a specific campaign
				# @param [String] access_token
				# @param [Integer] campaign_id
				# @return [Campaign]
				def get_campaign(access_token, campaign_id)
					url = Util::Config.get('endpoints.base_url') + sprintf(Util::Config.get('endpoints.campaigns'), campaign_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::Campaign.from_array(JSON.parse(response.body))
				end

			end
		end
	end
end