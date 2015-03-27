#
# activity_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::ActivityService do
  describe "#get_activities" do
    it "gets a set of activities" do
      json_response = load_file('activities_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      activities = ConstantContact::Services::ActivityService.get_activities()
      activities.first.should be_kind_of(ConstantContact::Components::Activity)
      activities.first.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end

  describe "#get_activity" do
    it "gets an activity" do
      json_response = load_file('activity_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:get).and_return(response)

      activity = ConstantContact::Services::ActivityService.get_activity('a07e1ilbm7shdg6ikeo')
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end

  describe "#create_add_contacts_activity" do
    it "creates an Add Contacts Activity" do
      json_add_contacts = load_file('add_contacts_response.json')
      json_lists = load_file('lists_response.json')
      json_contacts = load_file('contacts_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_add_contacts, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      import = ConstantContact::Components::AddContactsImportData.new
      address = ConstantContact::Components::Address.create(
        :line1 => "1601 Trapelo Rd",
        :city => "Waltham",
        :state => "MA"
      )
      import.add_address(address)

      custom_field = ConstantContact::Components::CustomField.create(
        :name => "custom_field_1",
        :value => "my custom value"
      )
      import.add_custom_field(custom_field)
      import.add_email("abc@def.com")

      contacts = []
      contacts << import
      contacts_objects = JSON.parse(json_contacts)
      contacts_objects['results'].each do |contact|
        contacts << ConstantContact::Components::Contact.create(contact)
      end

      lists = []
      lists_objects = JSON.parse(json_lists)
      lists_objects.each do |list|
        lists << ConstantContact::Components::ContactList.create(list)
      end

      add_contact = ConstantContact::Components::AddContacts.new(contacts, lists)

      activity = ConstantContact::Services::ActivityService.create_add_contacts_activity(add_contact)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('ADD_CONTACTS')
    end
  end

  describe "#create_add_contacts_activity_from_file" do
    it "creates an Add Contacts Activity from a file" do
      content = load_file('add_contacts_request.csv')
      json = load_file('add_contacts_response.json')
      lists = 'list1, list2'
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      activity = ConstantContact::Services::ActivityService.create_add_contacts_activity_from_file(
        'contacts.txt', content, lists)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('ADD_CONTACTS')
    end
  end

  describe "#add_clear_lists_activity" do
    it "creates a Clear Lists Activity" do
      json_clear_lists = load_file('clear_lists_response.json')
      json_list = load_file('list_response.json')

      lists = []
      lists <<  ConstantContact::Components::ContactList.create(JSON.parse(json_list))

      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_clear_lists, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      activity = ConstantContact::Services::ActivityService.add_clear_lists_activity(lists)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('CLEAR_CONTACTS_FROM_LISTS')
    end
  end

  describe "#add_remove_contacts_from_lists_activity" do
    it "creates a Remove Contacts From Lists Activity" do
      json = load_file('remove_contacts_response.json')
      lists = 'list1, list2'
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:post).and_return(response)
      email_addresses = ["djellesma@constantcontact.com"]

      activity = ConstantContact::Services::ActivityService.add_remove_contacts_from_lists_activity(
        email_addresses, lists)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end

  describe "#add_remove_contacts_from_lists_activity_from_file" do
    it "creates a Remove Contacts Activity from a file" do
      content = load_file('remove_contacts_request.txt')
      json = load_file('remove_contacts_response.json')
      lists = 'list1, list2'
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      activity = ConstantContact::Services::ActivityService.add_remove_contacts_from_lists_activity_from_file(
        'contacts.txt', content, lists)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end

  describe "#add_export_contacts_activity" do
    it "creates an Export Contacts Activity" do
      json_request = load_file('export_contacts_request.json')
      json_response = load_file('export_contacts_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      export_contacts = ConstantContact::Components::ExportContacts.new(JSON.parse(json_request))

      activity = ConstantContact::Services::ActivityService.add_export_contacts_activity(export_contacts)
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('EXPORT_CONTACTS')
    end
  end

  describe "#add_remove_contacts_from_lists_activity" do
    it "creates a Remove Contacts From Lists Activity" do
      json_request = load_file('remove_contacts_from_lists_request.json')
      json_response = load_file('remove_contacts_from_lists_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {})
      RestClient.stub(:post).and_return(response)

      request_object = JSON.parse(json_request)
      
      lists = [], email_addresses = []
      request_object['lists'].each do |list|
        lists << ConstantContact::Components::ContactList.create(:id => list)
      end
      request_object['import_data'].each do |data|
        data['email_addresses'].each do |email_address|
          email_addresses << email_address
        end
      end

      activity = ConstantContact::Services::ActivityService.add_remove_contacts_from_lists_activity(email_addresses, lists)
      activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end
end