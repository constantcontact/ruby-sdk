#
# api_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Api do

  before(:all) do
    ConstantContact::Util::Config.configure do |config|
      config[:auth].delete :api_key
      config[:auth].delete :api_secret
      config[:auth].delete :redirect_uri
    end
  end

  it "without api_key defined" do
    lambda { 
      ConstantContact::Api.new
    }.should raise_error(ArgumentError, ConstantContact::Util::Config.get('errors.api_key_missing'))
  end

  it "without access_token defined" do
    lambda { 
      ConstantContact::Api.new('api_key')
    }.should raise_error(ArgumentError, ConstantContact::Util::Config.get('errors.access_token_missing'))
  end

  context "with middle-ware configuration" do
    before(:all) do
      ConstantContact::Services::BaseService.api_key = nil
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
    end
    let(:proc) { lambda { ConstantContact::Api.new } }
    it "use implicit config" do
      proc.should raise_error(ArgumentError, ConstantContact::Util::Config.get('errors.access_token_missing'))
    end
    it "has the correct implicit api key" do
      ConstantContact::Services::BaseService.api_key.should == "config_api_key"
    end
  end

  context "with middle-ware configuration" do
    before(:all) do
      ConstantContact::Services::BaseService.api_key = nil
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
      ConstantContact::Api.new('explicit_api_key', 'access_token')
    end
    it "has the correct explicit api key" do
      ConstantContact::Services::BaseService.api_key.should == "explicit_api_key"
    end
  end

  describe "test methods" do
    before(:each) do
      @api = ConstantContact::Api.new('api key', 'access token')
      @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
    end

    describe "#get_account_info" do
      it "gets a summary of account information" do
        json_response = load_file('account_info_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        result = @api.get_account_info()
        result.should be_kind_of(ConstantContact::Components::AccountInfo)
        result.website.should eq('http://www.example.com')
      end
    end

    describe "#get_verified_email_addresses" do
      it "gets verified addresses for the account" do
        json_response = load_file('verified_email_addresses_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        email_addresses = @api.get_verified_email_addresses()

        email_addresses.should be_kind_of(Array)
        email_addresses.first.should be_kind_of(ConstantContact::Components::VerifiedEmailAddress)
        email_addresses.first.email_address.should eq('abc@def.com')
      end
    end

    describe "#get_contacts" do
      it "returns an array of contacts" do
        json_response = load_file('contacts_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        contacts = @api.get_contacts({:limit => 60})

        contacts.should be_kind_of(ConstantContact::Components::ResultSet)
        contacts.results.first.should be_kind_of(ConstantContact::Components::Contact)
        contacts.results.first.fax.should eq('318-978-7575')
      end
    end

    describe "#get_contact" do
      it "returns a contact" do
        json_response = load_file('contact_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        contact = @api.get_contact(1)

        contact.should be_kind_of(ConstantContact::Components::Contact)
      end
    end

    describe "#get_contact_by_email" do
      it "returns a contact" do
        json_response = load_file('contacts_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        contacts = @api.get_contact_by_email('rmartone@systems.com')

        contacts.results.first.should be_kind_of(ConstantContact::Components::Contact)
      end
    end

    describe "#add_contact" do
      it "adds a contact" do
        json_response = load_file('contact_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        new_contact = ConstantContact::Components::Contact.create(JSON.parse(json_response))

        contact = @api.add_contact(new_contact)
        contact.should be_kind_of(ConstantContact::Components::Contact)
        contact.status.should eq('ACTIVE')
      end
    end

    describe "#delete_contact" do
      it "deletes a contact" do
        contact_id = 196
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_contact(contact_id)
        result.should be_true
      end
    end

    describe "#delete_contact_from_lists" do
      it "deletes a contact" do
        contact_id = 196
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_contact_from_lists(contact_id)
        result.should be_true
      end
    end

    describe "#delete_contact_from_list" do
      it "deletes a contact" do
        contact_id = 196
        list_id = 1
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_contact_from_list(contact_id, list_id)
        result.should be_true
      end
    end

    describe "#update_contact" do
      it "updates a contact" do
        json = load_file('contact_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        contact = ConstantContact::Components::Contact.create(JSON.parse(json))
        result = @api.update_contact(contact)

        result.should be_kind_of(ConstantContact::Components::Contact)
        result.status.should eq('ACTIVE')
      end
    end

    describe "#get_lists" do
      it "returns an array of lists" do
        json_response = load_file('lists_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        lists = @api.get_lists()

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

        list = @api.get_list(1)
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

        list = @api.add_list(new_list)
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

        result = @api.update_list(list)
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

        contacts = @api.get_contacts_from_list(list, "?limit=4&next=true")
        contacts.should be_kind_of(ConstantContact::Components::ResultSet)
        contacts.results.first.should be_kind_of(ConstantContact::Components::Contact)
        contacts.results.first.fax.should eq('318-978-7575')

        contacts = @api.get_contacts_from_list(list, 4)
        contacts.should be_kind_of(ConstantContact::Components::ResultSet)
        contacts.results.first.should be_kind_of(ConstantContact::Components::Contact)
        contacts.results.first.fax.should eq('318-978-7575')
      end
    end

    describe "#get_events" do
      it "returns an array of events" do
        json = load_file('events.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        
        events = @api.get_events()
        events.should be_kind_of(ConstantContact::Components::ResultSet)
        events.results.collect{|e| e.should be_kind_of(ConstantContact::Components::Event) }
      end
    end

    describe "#get_event" do
      it "returns an event" do
        json = load_file('event.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        event = @api.get_event(1)

        event.should be_kind_of(ConstantContact::Components::Event)
      end
    end

    describe "#add_event" do
      it "adds an event" do
        json = load_file('event.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(json))
        added = @api.add_event(event)

        added.should respond_to(:id)
        added.id.should_not be_empty
      end
    end

    describe "#publish_event" do
      it "updates an event with status of ACTIVE" do
        json = load_file('event.json')
        hash = JSON.parse json
        hash["status"] = "ACTIVE"

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(hash.to_json, net_http_resp, {}, @request)
        RestClient.stub(:patch).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(json))
        updated = @api.publish_event(event)
        updated.should be_kind_of(ConstantContact::Components::Event)
        updated.should respond_to(:status)
        updated.status.should eq("ACTIVE")
      end
    end

    describe "#cancel_event" do
      it "updates an event's status to CANCELLED" do
        json = load_file('event.json')
        hash =  JSON.parse json
        hash["status"] = "CANCELLED"

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(hash.to_json, net_http_resp, {}, @request)
        RestClient.stub(:patch).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(json))
        updated = @api.cancel_event(event)
        updated.should be_kind_of(ConstantContact::Components::Event)
        updated.should respond_to(:status)
        updated.status.should eq("CANCELLED")
      end
    end

    describe "#get_fees" do
      it "returns an array of fees for an event" do
        event_json = load_file('event.json')
        fees_json = load_file('fees.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(fees_json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)
        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fees = @api.get_event_fees(event)
        #fees.should be_kind_of(ConstantContact::Components::ResultSet)
        #fees.results.collect{|f| f.should be_kind_of(ConstantContact::Components::Fee) }

        fees.should be_kind_of(Array) # inconsistent with oether APIs.
        fees.collect{|f| f.should be_kind_of(ConstantContact::Components::EventFee) }
      end
    end

    describe "#get_fee" do
      it "return an event fee" do
        event_json = load_file('event.json')
        fee_json = load_file('fees.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(fee_json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
        retrieved = @api.get_event_fee(event, fee)
        retrieved.should be_kind_of(ConstantContact::Components::EventFee)
      end
    end

    describe "#add_fee" do
      it "adds an event fee" do
        event_json = load_file('event.json')
        fee_json = load_file('fee.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
        response = RestClient::Response.create(fee_json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
        added = @api.add_event_fee(event, fee)
        added.should be_kind_of(ConstantContact::Components::EventFee)
        added.id.should_not be_empty
      end
    end

    describe "#update_fee" do
      it "updates an event fee" do
        event_json = load_file('event.json')
        fee_json = load_file('fee.json')
        hash = JSON.parse fee_json
        hash['fee'] += 1

        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
        response = RestClient::Response.create(hash.to_json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
        updated = @api.update_event_fee(event, fee)
        updated.should be_kind_of(ConstantContact::Components::EventFee)
        updated.fee.should_not eq(fee.fee)
        updated.fee.should eq(fee.fee + 1)
      end
    end

    describe "#delete_fee" do
      it "deletes an event fee" do
        event_json = load_file('event.json')
        fee_json = load_file('fees.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')
        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
        @api.delete_event_fee(event, fee).should be_true
      end
    end

    describe "#get_registrants" do
      it "returns an array of event registrants" do
        event_json = load_file('event.json')
        registrants_json = load_file('registrants.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
        response = RestClient::Response.create(registrants_json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        registrants = @api.get_event_registrants(event)
        registrants.should be_kind_of(ConstantContact::Components::ResultSet)
        registrants.results.collect{|r| r .should be_kind_of(ConstantContact::Components::Registrant) }
      end
    end

    describe "#get_registrant" do
      it "returns an event registrant" do
        event_json = load_file('event.json')
        registrant_json = load_file('registrant.json')

        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
        response = RestClient::Response.create(registrant_json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        registrant = ConstantContact::Components::Registrant.create(JSON.parse(registrant_json))
        retrieved = @api.get_event_registrant(event, registrant)
        retrieved.should be_kind_of(ConstantContact::Components::Registrant)
        retrieved.id.should_not be_empty
      end
    end

    describe "#get_event_items" do
      it "returns an array of event items" do
        json_response = load_file('event_items_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        results = @api.get_event_items(1)
        results.should be_kind_of(Array)
        results.first.should be_kind_of(ConstantContact::Components::EventItem)
        results.first.name.should eq('Running Belt')
      end
    end

    describe "#get_event_item" do
      it "returns an event item" do
        json = load_file('event_item_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        result = @api.get_event_item(1, 1)
        result.should be_kind_of(ConstantContact::Components::EventItem)
        result.name.should eq('Running Belt')
      end
    end

    describe "#add_event_item" do
      it "adds an event item" do
        json = load_file('event_item_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        event_item = ConstantContact::Components::EventItem.create(JSON.parse(json))

        result = @api.add_event_item(1, event_item)
        result.should be_kind_of(ConstantContact::Components::EventItem)
        result.name.should eq('Running Belt')
      end
    end

    describe "#delete_event_item" do
      it "deletes an event item" do
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_event_item(1, 1)
        result.should be_true
      end
    end

    describe "#update_event_item" do
      it "updates an event item" do
        json = load_file('event_item_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        event_item = ConstantContact::Components::EventItem.create(JSON.parse(json))

        result = @api.update_event_item(1, event_item)
        result.should be_kind_of(ConstantContact::Components::EventItem)
        result.name.should eq('Running Belt')
      end
    end

    describe "#get_event_item_attributes" do
      it "returns an array of event item attributes" do
        json_response = load_file('event_item_attributes_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        results = @api.get_event_item_attributes(1, 1)
        results.should be_kind_of(Array)
        results.first.should be_kind_of(ConstantContact::Components::EventItemAttribute)
        results.first.name.should eq('Royal Blue')
      end
    end

    describe "#get_event_item_attribute" do
      it "returns an event item attribute" do
        json = load_file('event_item_attribute_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        result = @api.get_event_item_attribute(1, 1, 1)
        result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
        result.name.should eq('Hi-Vis Green')
      end
    end

    describe "#add_event_item_attribute" do
      it "adds an event item attribute" do
        json = load_file('event_item_attribute_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        event_item_attribute = ConstantContact::Components::EventItemAttribute.create(JSON.parse(json))

        result = @api.add_event_item_attribute(1, 1, event_item_attribute)
        result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
        result.name.should eq('Hi-Vis Green')
      end
    end

    describe "#delete_event_item_attribute" do
      it "deletes an event item attribute" do
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_event_item_attribute(1, 1, 1)
        result.should be_true
      end
    end

    describe "#update_event_item_attribute" do
      it "updates an event item attribute" do
        json = load_file('event_item_attribute_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        event_item_attribute = ConstantContact::Components::EventItemAttribute.create(JSON.parse(json))

        result = @api.update_event_item_attribute(1, 1, event_item_attribute)
        result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
        result.name.should eq('Hi-Vis Green')
      end
    end

    describe "#get_promocodes" do
      it "returns an array of promocodes" do
        json_response = load_file('promocodes_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        results = @api.get_promocodes(1)
        results.should be_kind_of(Array)
        results.first.should be_kind_of(ConstantContact::Components::Promocode)
        results.first.code_name.should eq('REDUCED_FEE')
      end
    end

    describe "#get_promocode" do
      it "returns a promocode" do
        json = load_file('promocode_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        result = @api.get_promocode(1, 1)
        result.should be_kind_of(ConstantContact::Components::Promocode)
        result.code_name.should eq('TOTAL_FEE')
      end
  end

    describe "#add_promocode" do
      it "adds a promocode" do
        json = load_file('promocode_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        promocode = ConstantContact::Components::Promocode.create(JSON.parse(json))

        result = @api.add_promocode(1, promocode)
        result.should be_kind_of(ConstantContact::Components::Promocode)
        result.code_name.should eq('TOTAL_FEE')
      end
    end

    describe "#delete_promocode" do
      it "deletes a promocode" do
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_promocode(1, 1)
        result.should be_true
      end
    end

    describe "#update_promocode" do
      it "updates an event item" do
        json = load_file('promocode_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        promocode = ConstantContact::Components::Promocode.create(JSON.parse(json))

        result = @api.update_promocode(1, promocode)
        result.should be_kind_of(ConstantContact::Components::Promocode)
        result.code_name.should eq('TOTAL_FEE')
      end
    end

    describe "#get_email_campaigns" do
      it "gets a set of campaigns" do
        json_response = load_file('email_campaigns_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        campaigns = @api.get_email_campaigns({:limit => 2})
        campaigns.should be_kind_of(ConstantContact::Components::ResultSet)
        campaigns.results.first.should be_kind_of(ConstantContact::Components::Campaign)
        campaigns.results.first.name.should eq('1357157252225')
      end
    end

    describe "#get_email_campaign" do
      it "gets an individual campaign" do
        json_response = load_file('email_campaign_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        campaign = @api.get_email_campaign(1)
        campaign.should be_kind_of(ConstantContact::Components::Campaign)
        campaign.name.should eq('Campaign Name')
      end
    end

    describe "#add_email_campaign" do
      it "creates a new campaign" do
        json = load_file('email_campaign_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        new_campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

        campaign = @api.add_email_campaign(new_campaign)
        campaign.should be_kind_of(ConstantContact::Components::Campaign)
        campaign.name.should eq('Campaign Name')
      end
    end

    describe "#delete_email_campaign" do
      it "deletes an individual campaign" do
        json = load_file('email_campaign_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)
        campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

        result = @api.delete_email_campaign(campaign)
        result.should be_true
      end
    end

    describe "#update_email_campaign" do
      it "updates a specific campaign" do
        json = load_file('email_campaign_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        campaign = ConstantContact::Components::Campaign.create(JSON.parse(json))

        result = @api.update_email_campaign(campaign)
        result.should be_kind_of(ConstantContact::Components::Campaign)
        result.name.should eq('Campaign Name')
      end
    end

    describe "#add_email_campaign_schedule" do
      it "schedules a campaign to be sent" do
        campaign_id = 1
        json = load_file('schedule_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        new_schedule = ConstantContact::Components::Schedule.create(JSON.parse(json))

        schedule = @api.add_email_campaign_schedule(campaign_id, new_schedule)
        schedule.should be_kind_of(ConstantContact::Components::Schedule)
        schedule.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
      end
    end

    describe "#get_email_campaign_schedules" do
      it "gets an array of schedules associated with a given campaign" do
        campaign_id = 1
        json = load_file('schedules_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        schedules = @api.get_email_campaign_schedules(campaign_id)
        schedules.first.should be_kind_of(ConstantContact::Components::Schedule)
        schedules.first.scheduled_date.should eq('2012-12-16T11:07:43.626Z')
      end
    end

    describe "#get_email_campaign_schedule" do
      it "gets a specific schedule associated with a given campaign" do
        campaign_id = 1
        schedule_id = 1

        json = load_file('schedule_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        schedule = @api.get_email_campaign_schedule(campaign_id, schedule_id)
        schedule.should be_kind_of(ConstantContact::Components::Schedule)
        schedule.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
      end
    end

    describe "#delete_email_campaign_schedule" do
      it "deletes a specific schedule associated with a given campaign" do
        campaign_id = 1
        schedule_id = 1
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_email_campaign_schedule(campaign_id, schedule_id)
        result.should be_true
      end
    end

    describe "#update_email_campaign_schedule" do
      it "updates a specific schedule associated with a given campaign" do
        campaign_id = 1
        json = load_file('schedule_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        schedule = ConstantContact::Components::Schedule.create(JSON.parse(json))

        result = @api.update_email_campaign_schedule(campaign_id, schedule)
        result.should be_kind_of(ConstantContact::Components::Schedule)
        result.scheduled_date.should eq('2013-05-10T11:07:43.626Z')
      end
    end

    describe "#send_email_campaign_test" do
      it "sends a test send of a campaign" do
        campaign_id = 1
        json_request = load_file('test_send_request.json')
        json_response = load_file('test_send_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        test_send = ConstantContact::Components::TestSend.create(JSON.parse(json_request))

        result = @api.send_email_campaign_test(campaign_id, test_send)
        result.should be_kind_of(ConstantContact::Components::TestSend)
        result.personal_message.should eq('This is a test send of the email campaign message.')
      end
    end

    describe "#get_email_campaign_bounces" do
      it "gets bounces for a campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_bounces_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_bounces(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::BounceActivity)
        set.results.first.activity_type.should eq('EMAIL_BOUNCE')
      end
    end

    describe "#get_email_campaign_clicks" do
      it "gets clicks for a campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_clicks_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_clicks(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::ClickActivity)
        set.results.first.activity_type.should eq('EMAIL_CLICK')
      end
    end

    describe "#get_email_campaign_forwards" do
      it "gets forwards for a campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_forwards_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_forwards(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::ForwardActivity)
        set.results.first.activity_type.should eq('EMAIL_FORWARD')
      end
    end

    describe "#get_email_campaign_opens" do
      it "gets opens for a campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_opens_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_opens(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::OpenActivity)
        set.results.first.activity_type.should eq('EMAIL_OPEN')
      end
    end

    describe "#get_email_campaign_sends" do
      it "gets sends for a given campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_sends_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_sends(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::SendActivity)
        set.results.first.activity_type.should eq('EMAIL_SEND')
      end
    end

    describe "#get_email_campaign_unsubscribes" do
      it "gets unsubscribes for a campaign" do
        campaign_id = 1
        params = {:limit => 5}
        json = load_file('campaign_tracking_unsubscribes_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_email_campaign_unsubscribes(campaign_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::UnsubscribeActivity)
        set.results.first.activity_type.should eq('EMAIL_UNSUBSCRIBE')
      end
    end

    describe "#get_email_campaign_summary_report" do
      it "gets a reporting summary for a campaign" do
        campaign_id = 1
        json = load_file('campaign_tracking_summary_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        summary = @api.get_email_campaign_summary_report(campaign_id)
        summary.should be_kind_of(ConstantContact::Components::TrackingSummary)
        summary.sends.should eq(15)
      end
    end

    describe "#get_contact_bounces" do
      it "gets bounces for a contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_bounces_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_bounces(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::BounceActivity)
        set.results.first.activity_type.should eq('EMAIL_BOUNCE')
      end
    end

    describe "#get_contact_clicks" do
      it "gets clicks for a contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_clicks_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_clicks(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::ClickActivity)
        set.results.first.activity_type.should eq('EMAIL_CLICK')
      end
    end

    describe "#get_contact_forwards" do
      it "gets forwards for a contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_forwards_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_forwards(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::ForwardActivity)
        set.results.first.activity_type.should eq('EMAIL_FORWARD')
      end
    end

    describe "#get_contact_opens" do
      it "gets opens for a given contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_opens_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_opens(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::OpenActivity)
        set.results.first.activity_type.should eq('EMAIL_OPEN')
      end
    end

    describe "#get_contact_sends" do
      it "gets sends for a contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_sends_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_sends(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::SendActivity)
        set.results.first.activity_type.should eq('EMAIL_SEND')
      end
    end

    describe "#get_contact_unsubscribes" do
      it "gets unsubscribes for a given contact" do
        contact_id = 1
        params = {:limit => 5}
        json = load_file('contact_tracking_unsubscribes_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        set = @api.get_contact_unsubscribes(contact_id, params)
        set.should be_kind_of(ConstantContact::Components::ResultSet)
        set.results.first.should be_kind_of(ConstantContact::Components::UnsubscribeActivity)
        set.results.first.activity_type.should eq('EMAIL_UNSUBSCRIBE')
      end
    end

    describe "#get_contact_summary_report" do
      it "gets a reporting summary for a Contact" do
        contact_id = 1
        json = load_file('contact_tracking_summary_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        summary = @api.get_contact_summary_report(contact_id)
        summary.should be_kind_of(ConstantContact::Components::TrackingSummary)
        summary.sends.should eq(15)
      end
    end

    describe "#get_activities" do
      it "gets an array of activities" do
        json_response = load_file('activities_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        activities = @api.get_activities()
        activities.first.should be_kind_of(ConstantContact::Components::Activity)
        activities.first.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
      end
    end

    describe "#update_email_campaign" do
      it "updates a specific campaign" do
        json_response = load_file('activity_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        activity = @api.get_activity('a07e1ilbm7shdg6ikeo')
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
      end
    end

    describe "#add_create_contacts_activity" do
      it "adds an AddContacts activity to add contacts in bulk" do
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

        JSON.parse(json_request).should eq(JSON.parse(JSON.generate(add_contact)))

        activity = @api.add_create_contacts_activity(add_contact)
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('ADD_CONTACTS')
      end
    end

    describe "#add_create_contacts_activity_from_file" do
      it "creates an Add Contacts Activity from a file. Valid file types are txt, csv, xls, xlsx" do
        content = load_file('add_contacts_request.csv')
        json = load_file('add_contacts_response.json')
        lists = 'list1, list2'
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        activity = @api.add_create_contacts_activity_from_file('contacts.txt', content, lists)
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('ADD_CONTACTS')
      end
    end

    describe "#add_clear_lists_activity" do
      it "adds a ClearLists Activity to remove all contacts from the provided lists" do
        json_clear_lists = load_file('clear_lists_response.json')
        json_list = load_file('list_response.json')

        lists = []
        lists << ConstantContact::Components::ContactList.create(JSON.parse(json_list))

        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_clear_lists, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        activity = @api.add_clear_lists_activity(lists)
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('CLEAR_CONTACTS_FROM_LISTS')
      end
    end

    describe "#add_remove_contacts_from_lists_activity" do
      it "adds a Remove Contacts From Lists Activity" do
        json = load_file('remove_contacts_response.json')
        lists = 'list1, list2'
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        email_addresses = ["djellesma@constantcontact.com"]

        activity = @api.add_remove_contacts_from_lists_activity(
          email_addresses, lists)
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('REMOVE_CONTACTS_FROM_LISTS')
      end
    end

    describe "#add_remove_contacts_from_lists_activity_from_file" do
      it "adds a Remove Contacts From Lists Activity from a file. Valid file types are txt, csv, xls, xlsx" do
        content = load_file('remove_contacts_request.txt')
        json = load_file('remove_contacts_response.json')
        lists = 'list1, list2'
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        activity = @api.add_remove_contacts_from_lists_activity_from_file('contacts.txt', content, lists)
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

        activity = @api.add_export_contacts_activity(export_contacts)
        activity.should be_kind_of(ConstantContact::Components::Activity)
        activity.type.should eq('EXPORT_CONTACTS')
      end
    end

    describe "#get_library_info" do
      it "retrieves a MyLibrary usage information" do
        json_response = load_file('library_info_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        info = @api.get_library_info()
        info.should be_kind_of(ConstantContact::Components::LibrarySummary)
        info.usage_summary['folder_count'].should eq(6)
      end
    end

    describe "#get_library_folders" do
      it "retrieves a list of MyLibrary folders" do
        json_response = load_file('library_folders_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        folders = @api.get_library_folders({:limit => 2})
        folders.should be_kind_of(ConstantContact::Components::ResultSet)
        folders.results.first.should be_kind_of(ConstantContact::Components::LibraryFolder)
        folders.results.first.name.should eq('backgrounds')
      end
    end

    describe "#add_library_folder" do
      it "creates a new MyLibrary folder" do
        json = load_file('library_folder_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)
        new_folder = ConstantContact::Components::LibraryFolder.create(JSON.parse(json))

        folder = @api.add_library_folder(new_folder)
        folder.should be_kind_of(ConstantContact::Components::LibraryFolder)
        folder.name.should eq('wildflowers')
      end
    end

    describe "#get_library_folder" do
      it "retrieves a specific MyLibrary folder using the folder_id path parameter" do
        json = load_file('library_folder_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        folder = @api.get_library_folder(6)
        folder.should be_kind_of(ConstantContact::Components::LibraryFolder)
        folder.name.should eq('wildflowers')
      end
    end

    describe "#update_library_folder" do
      it "retrieves a specific MyLibrary folder using the folder_id path parameter" do
        json = load_file('library_folder_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        folder = ConstantContact::Components::LibraryFolder.create(JSON.parse(json))

        response = @api.update_library_folder(folder)
        response.should be_kind_of(ConstantContact::Components::LibraryFolder)
        response.name.should eq('wildflowers')
      end
    end

    describe "#delete_library_folder" do
      it "deletes a MyLibrary folder" do
        folder_id = 6
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_library_folder(folder_id)
        result.should be_true
      end
    end

    describe "#get_library_trash" do
      it "retrieve all files in the Trash folder" do
        json = load_file('library_trash_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        files = @api.get_library_trash({:sort_by => 'SIZE_DESC'})
        files.should be_kind_of(ConstantContact::Components::ResultSet)
        files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
        files.results.first.name.should eq('menu_form.pdf')
      end
    end

    describe "#delete_library_trash" do
      it "permanently deletes all files in the Trash folder" do
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_library_trash()
        result.should be_true
      end
    end

    describe "#get_library_files" do
      it "retrieves a collection of MyLibrary files in the Constant Contact account" do
        json_response = load_file('library_files_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        files = @api.get_library_files({:type => 'ALL'})
        files.should be_kind_of(ConstantContact::Components::ResultSet)
        files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
        files.results.first.name.should eq('IMG_0341.JPG')
      end
    end

    describe "#get_library_files_by_folder" do
      it "retrieves a collection of MyLibrary files in the Constant Contact account" do
        folder_id = -1
        json_response = load_file('library_files_by_folder_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json_response, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        files = @api.get_library_files_by_folder(folder_id, {:limit => 10})
        files.should be_kind_of(ConstantContact::Components::ResultSet)
        files.results.first.should be_kind_of(ConstantContact::Components::LibraryFile)
        files.results.first.name.should eq('IMG_0341.JPG')
      end
    end

    describe "#get_library_file" do
      it "retrieve a MyLibrary file using the file_id path parameter" do
        json = load_file('library_file_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        file = @api.get_library_file(6)
        file.should be_kind_of(ConstantContact::Components::LibraryFile)
        file.name.should eq('IMG_0261.JPG')
      end
    end

    describe "#add_library_file" do
      it "adds a new MyLibrary file using the multipart content-type" do
        file_name = 'logo.jpg'
        folder_id = 1
        description = 'Logo'
        source = 'MyComputer'
        file_type = 'JPG'
        contents = load_file('logo.jpg')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        net_http_resp.add_field('Location', '"https://api.d1.constantcontact.com/v2/library/files/123456789')

        response = RestClient::Response.create("", net_http_resp, {}, @request)
        RestClient.stub(:post).and_return(response)

        response = @api.add_library_file(file_name, folder_id, description, source, file_type, contents)
        response.should be_kind_of(String)
        response.should eq('123456789')
      end
    end

    describe "#update_library_file" do
      it "updates information for a specific MyLibrary file" do
        json = load_file('library_file_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)
        file = ConstantContact::Components::LibraryFile.create(JSON.parse(json))

        response = @api.update_library_file(file)
        response.should be_kind_of(ConstantContact::Components::LibraryFile)
        response.name.should eq('IMG_0261.JPG')
      end
    end

    describe "#delete_library_file" do
      it "deletes one or more MyLibrary files specified by the fileId path parameter" do
        file_id = '6, 7'
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

        response = RestClient::Response.create('', net_http_resp, {}, @request)
        RestClient.stub(:delete).and_return(response)

        result = @api.delete_library_file(file_id)
        result.should be_true
      end
    end

    describe "#get_library_files_upload_status" do
      it "retrieves the upload status for one or more MyLibrary files using the file_id path parameter" do
        file_id = '6, 7'
        json = load_file('library_files_upload_status_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:get).and_return(response)

        statuses = @api.get_library_files_upload_status(file_id)
        statuses.should be_kind_of(Array)
        statuses.first.should be_kind_of(ConstantContact::Components::UploadStatus)
        statuses.first.status.should eq('Active')
      end
    end

    describe "#move_library_files" do
      it "moves one or more MyLibrary files to a different folder in the user's account" do
        folder_id = 1
        file_id = '8, 9'
        json = load_file('library_files_move_results_response.json')
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

        response = RestClient::Response.create(json, net_http_resp, {}, @request)
        RestClient.stub(:put).and_return(response)

        results = @api.move_library_files(folder_id, file_id)
        results.should be_kind_of(Array)
        results.first.should be_kind_of(ConstantContact::Components::MoveResults)
        results.first.uri.should eq('https://api.d1.constantcontact.com/v2/library/files/9')
      end
    end
  end
end