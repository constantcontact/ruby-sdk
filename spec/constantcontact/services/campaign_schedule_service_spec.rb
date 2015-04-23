#
# campaign_schedule_service_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::CampaignScheduleService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
  end

  describe "#add_schedule" do
    it "creates a new schedule for a campaign" do
      campaign_id = 1
      json = load_file('schedule_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:post).and_return(response)
      new_schedule = ConstantContact::Components::Schedule.create(JSON.parse(json))

      schedule = ConstantContact::Services::CampaignScheduleService.add_schedule(
        campaign_id, new_schedule)
      schedule.should be_kind_of(ConstantContact::Components::Schedule)
      schedule.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
    end
  end

  describe "#get_schedules" do
    it "gets a list of schedules for a campaign" do
      campaign_id = 1
      json = load_file('schedules_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      schedules = ConstantContact::Services::CampaignScheduleService.get_schedules(
        campaign_id)
      schedules.first.should be_kind_of(ConstantContact::Components::Schedule)
      schedules.first.scheduled_date.should eq('2012-12-16T11:07:43.626Z')
    end
  end

  describe "#get_schedule" do
    it "gets a specific schedule for a campaign" do
      campaign_id = 1
      schedule_id = 1

      json = load_file('schedule_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      schedule = ConstantContact::Services::CampaignScheduleService.get_schedule(
        campaign_id, schedule_id)
      schedule.should be_kind_of(ConstantContact::Components::Schedule)
      schedule.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
    end
  end

  describe "#delete_schedule" do
    it "deletes a specific schedule for a campaign" do
      campaign_id = 1
      schedule_id = 1
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {}, @request)
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::CampaignScheduleService.delete_schedule(
        campaign_id, schedule_id)
      result.should be_true
    end
  end

  describe "#update_schedule" do
    it "updates a specific schedule for a campaign" do
      campaign_id = 1
      json = load_file('schedule_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:put).and_return(response)
      schedule = ConstantContact::Components::Schedule.create(JSON.parse(json))

      result = ConstantContact::Services::CampaignScheduleService.update_schedule(
        campaign_id, schedule)
      result.should be_kind_of(ConstantContact::Components::Schedule)
      result.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
    end
  end

  describe "#send_test" do
    it "sends a test send of a campaign" do
      campaign_id = 1
      json_request = load_file('test_send_request.json')
      json_response = load_file('test_send_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:post).and_return(response)
      test_send = ConstantContact::Components::TestSend.create(JSON.parse(json_request))

      result = ConstantContact::Services::CampaignScheduleService.send_test(
        campaign_id, test_send)
      result.should be_kind_of(ConstantContact::Components::TestSend)
      result.personal_message.should eq('This is a test send of the email campaign message.')
    end
  end

end