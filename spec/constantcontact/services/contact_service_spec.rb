#
# contact_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::ContactService do
  describe "#get_contacts" do
    it "returns an array of contacts" do
      json = load_file('contacts_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)
      contacts = ConstantContact::Services::ContactService.get_contacts('token')
      contact = contacts.results[0]

      contacts.should be_kind_of(ConstantContact::Components::ResultSet)
      contact.should be_kind_of(ConstantContact::Components::Contact)
    end
  end

  describe "#get_contact" do
    it "returns a contact" do
      json = load_file('contact_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:get).and_return(response)
      contact = ConstantContact::Services::ContactService.get_contact('token', 1)

      contact.should be_kind_of(ConstantContact::Components::Contact)
    end
  end

  describe "#add_contact" do
    it "adds a contact" do
      json = load_file('contact_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:post).and_return(response)
      new_contact = ConstantContact::Components::Contact.create(JSON.parse(json))
      contact = ConstantContact::Services::ContactService.add_contact('token', new_contact)

      contact.should be_kind_of(ConstantContact::Components::Contact)
      contact.status.should eq('ACTIVE')
    end
  end

  describe "#delete_contact" do
    it "deletes a contact" do
      contact_id = 196
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::ContactService.delete_contact('token', contact_id)
      result.should be_true
    end
  end

  describe "#delete_contact_from_lists" do
    it "deletes a contact" do
      contact_id = 196
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::ContactService.delete_contact_from_lists('token', contact_id)
      result.should be_true
    end
  end

  describe "#delete_contact_from_list" do
    it "deletes a contact" do
      contact_id = 196
      list_id = 1
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, {})
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::ContactService.delete_contact_from_list('token', contact_id, list_id)
      result.should be_true
    end
  end

  describe "#update_contact" do
    it "updates a contact" do
      json = load_file('contact_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:put).and_return(response)
      contact = ConstantContact::Components::Contact.create(JSON.parse(json))
      result = ConstantContact::Services::ContactService.update_contact('token', contact)

      result.should be_kind_of(ConstantContact::Components::Contact)
      result.status.should eq('ACTIVE')
    end
  end
end