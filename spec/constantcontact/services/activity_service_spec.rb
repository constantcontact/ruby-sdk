#
# activity_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::ActivityService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
  end

  describe "#get_activities" do
    it "gets a set of activities" do
      json_response = load_file('activities_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:get).and_return(response)

      activity = ConstantContact::Services::ActivityService.get_activity('a07e1ilbm7shdg6ikeo')
      activity.should be_kind_of(ConstantContact::Components::Activity)
      activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
    end
  end

  describe "#create_add_contacts_activity" do
    it "creates an Add Contacts Activity" do
      json_request = load_file('add_contacts_request.json')
      json_response = load_file('add_contacts_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
      RestClient.stub(:post).and_return(response)

      contacts = []

      # first contact
      import = ConstantContact::Components::AddContactsImportData.new({
          :first_name     => "John",
          :last_name      => "Smith",
          :birthday_month => "1",
          :birthday_day   => "25",
          :anniversary    => "03/12/2005",
          :job_title      => "",
          :company_name   => "My Company",
          :home_phone     => "5555551212"
      })

      # add emails
      import.add_email("user1@example.com")

      # add addresses
      address = ConstantContact::Components::Address.create(
        :line1        => "123 Partridge Lane",
        :line2        => "Apt. 3",
        :city         => "Anytown",
        :address_type => "PERSONAL",
        :state_code   => "NH",
        :country_code => "US",
        :postal_code  => "02145"
      )
      import.add_address(address)

      contacts << import

      # second contact
      import = ConstantContact::Components::AddContactsImportData.new({
        :first_name     => "Jane",
        :last_name      => "Doe",
        :job_title      => "",
        :company_name   => "Acme, Inc.",
        :home_phone     => "5555551213"
      })

      # add emails
      import.add_email("user2@example.com")

      # add addresses
      address = ConstantContact::Components::Address.create(
        :line1        => "456 Jones Road",
        :city         => "AnyTownShip",
        :address_type => "PERSONAL",
        :state_code   => "DE",
        :country_code => "US",
        :postal_code  => "01234"
      )
      import.add_address(address)

      # add custom fields
      custom_field = ConstantContact::Components::CustomField.create(
        :name  => "custom_field_6",
        :value => "Blue Jeans"
      )
      import.add_custom_field(custom_field)

      custom_field = ConstantContact::Components::CustomField.create(
        :name  => "custom_field_12",
        :value => "Special Order"
      )
      import.add_custom_field(custom_field)

      contacts << import

      lists = ['4', '5', '6']

      add_contact = ConstantContact::Components::AddContacts.new(contacts, lists)

      json_request.gsub(/\:\s/, ':').gsub(/\n\s{1,}/, '').gsub(/\n\}/, '}').should eq(JSON.generate(add_contact))

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

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json_clear_lists, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
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

      response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
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