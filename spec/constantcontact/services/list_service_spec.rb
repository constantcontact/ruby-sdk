#
# list_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::ListService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
  end

  describe "#get_lists" do
    it "returns an array of lists" do
      json_response = load_file('lists_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      lists = ConstantContact::Services::ListService.get_lists()
      lists.should be_kind_of(Array)
      lists.first.should be_kind_of(ConstantContact::Components::ContactList)
      lists.first.name.should eq('General Interest')
    end
  end

  describe "#get_list" do
    it "returns a list" do
      json = load_file('list_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      list = ConstantContact::Services::ListService.get_list(1)
      list.should be_kind_of(ConstantContact::Components::ContactList)
      list.name.should eq('Monthly Specials')
    end
  end

  describe "#add_list" do
    it "adds a list" do
      json = load_file('list_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:post).and_return(response)
      new_list = ConstantContact::Components::ContactList.create(JSON.parse(json))

      list = ConstantContact::Services::ListService.add_list(new_list)
      list.should be_kind_of(ConstantContact::Components::ContactList)
      list.status.should eq('ACTIVE')
    end
  end

  describe "#update_list" do
    it "updates a list" do
      json = load_file('list_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
      RestClient.stub(:put).and_return(response)
      list = ConstantContact::Components::ContactList.create(JSON.parse(json))

      result = ConstantContact::Services::ListService.update_list(list)
      result.should be_kind_of(ConstantContact::Components::ContactList)
      result.status.should eq('ACTIVE')
    end
  end

  describe "#get_contacts_from_list" do
    it "returns an array of contacts" do
      json_list = load_file('list_response.json')
      json_contacts = load_file('contacts_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_contacts, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)
      list = ConstantContact::Components::ContactList.create(JSON.parse(json_list))

      contacts = ConstantContact::Services::ListService.get_contacts_from_list(list)
      contacts.should be_kind_of(ConstantContact::Components::ResultSet)
      contacts.results.first.should be_kind_of(ConstantContact::Components::Contact)
      contacts.results.first.fax.should eq('318-978-7575')
    end
  end
end