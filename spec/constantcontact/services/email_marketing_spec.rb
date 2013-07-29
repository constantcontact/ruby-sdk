#
# email_marketing_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::EmailMarketingService do
	describe "#get_campaigns" do
		it "returns an array of campaigns" do
			json = load_json('campaigns.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			campaigns = ConstantContact::Services::EmailMarketingService.get_campaigns('token')
			campaign = campaigns.results[0]

			campaigns.should be_kind_of(ConstantContact::Components::ResultSet)
			campaign.should be_kind_of(ConstantContact::Components::Campaign)
		end
	end

	describe "#get_campaign" do
		it "returns a campaign" do
			json = load_json('campaign.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			campaign = ConstantContact::Services::EmailMarketingService.get_campaign('token', 1)

			campaign.should be_kind_of(ConstantContact::Components::Campaign)
		end
	end

	describe "#add_campaign" do
		it "adds a campaign" do
			json = load_json('campaign.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:post).and_return(response)
			campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))
			added = ConstantContact::Services::EmailMarketingService.add_campaign('token', campaign)

			added.should respond_to(:id)
			added.id.should_not be_empty
		end
	end

	describe "#delete_campaign" do
		it "deletes a campgin" do
			json = load_json('campaign.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

			response = RestClient::Response.create('', net_http_resp, {})
			RestClient.stub(:delete).and_return(response)
			campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))
			ConstantContact::Services::EmailMarketingService.delete_campaign('token', campaign).should be_true
		end
	end

	describe "#update_campaign" do
		it "updates a campaign" do
			json = load_json('campaign.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:put).and_return(response)
			campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))
			added = ConstantContact::Services::EmailMarketingService.update_campaign('token', campaign)
		end
	end
end