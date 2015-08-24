#
# email_marketing_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::EmailMarketingService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
  end

  describe "#get_campaigns" do
    it "returns an array of campaigns" do
      json_response = load_file('email_campaigns_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      campaigns = ConstantContact::Services::EmailMarketingService.get_campaigns()
      campaigns.should be_kind_of(ConstantContact::Components::ResultSet)
      campaigns.results.first.should be_kind_of(ConstantContact::Components::Campaign)
      campaigns.results.first.name.should eq('1357157252225')
    end
  end

  describe "#get_campaign" do
    it "returns a campaign" do
      json_response = load_file('email_campaign_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      campaign = ConstantContact::Services::EmailMarketingService.get_campaign(1)
      campaign.should be_kind_of(ConstantContact::Components::Campaign)
      campaign.name.should eq('Campaign Name')
    end
  end

  describe "#get_campaign_preview" do
    it "gets the preview of the given campaign" do
      json_response = load_file('email_campaign_preview_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      campaign_preview = ConstantContact::Services::EmailMarketingService.get_campaign_preview(1)
      campaign_preview.should be_kind_of(ConstantContact::Components::CampaignPreview)
      campaign_preview.subject.should eq('Subject Test')
    end
  end

  describe "#add_campaign" do
    it "adds a campaign" do
      json = load_file('email_campaign_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:post).and_return(response)
      new_campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

      campaign = ConstantContact::Services::EmailMarketingService.add_campaign(new_campaign)
      campaign.should be_kind_of(ConstantContact::Components::Campaign)
      campaign.name.should eq('Campaign Name')
    end
  end

  describe "#delete_campaign" do
    it "deletes a campaign" do
      json = load_file('email_campaign_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {}, @request)
      RestClient.stub(:delete).and_return(response)
      campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

      result = ConstantContact::Services::EmailMarketingService.delete_campaign(campaign)
      result.should be_true
    end
  end

  describe "#update_campaign" do
    it "updates a campaign" do
      json = load_file('email_campaign_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:put).and_return(response)
      campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

      result = ConstantContact::Services::EmailMarketingService.update_campaign(campaign)
      result.should be_kind_of(ConstantContact::Components::Campaign)
      result.name.should eq('Campaign Name')
    end
  end
end