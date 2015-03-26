#
# campaign_tracking_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::CampaignTrackingService do
  describe "#get_bounces" do
    it "gets bounces for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_bounces_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_bounces(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::BounceActivity)
      set.results.first.activity_type.should eq('EMAIL_BOUNCE')
    end
  end

  describe "#get_clicks" do
    it "gets clicks for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_clicks_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_clicks(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::ClickActivity)
      set.results.first.activity_type.should eq('EMAIL_CLICK')
    end
  end

  describe "#get_forwards" do
    it "gets forwards for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_forwards_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_forwards(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::ForwardActivity)
      set.results.first.activity_type.should eq('EMAIL_FORWARD')
    end
  end

  describe "#get_opens" do
    it "gets opens for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_opens_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_opens(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::OpenActivity)
      set.results.first.activity_type.should eq('EMAIL_OPEN')
    end
  end

  describe "#get_sends" do
    it "gets sends for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_sends_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_sends(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::SendActivity)
      set.results.first.activity_type.should eq('EMAIL_SEND')
    end
  end

  describe "#get_unsubscribes" do
    it "gets unsubscribes for a given campaign" do
      campaign_id = 1
      params = {:limit => 5}
      json = load_file('campaign_tracking_unsubscribes_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      set = ConstantContact::Services::CampaignTrackingService.get_unsubscribes(campaign_id, params)
      set.should be_kind_of(ConstantContact::Components::ResultSet)
      set.results.first.should be_kind_of(ConstantContact::Components::UnsubscribeActivity)
      set.results.first.activity_type.should eq('EMAIL_UNSUBSCRIBE')
    end
  end

  describe "#get_summary" do
    it "gets a summary of reporting data for a given campaign" do
      campaign_id = 1
      json = load_file('campaign_tracking_summary_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      summary = ConstantContact::Services::CampaignTrackingService.get_summary(campaign_id)
      summary.should be_kind_of(ConstantContact::Components::TrackingSummary)
      summary.sends.should eq(15)
    end
  end

end