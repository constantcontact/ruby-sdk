#
# event_spot_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::EventSpotService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
    @client = ConstantContact::Api.new('explicit_api_key', "access_token")
  end

  describe "#get_events" do
    it "returns a set of events" do
      json = load_file('events.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)
      events = ConstantContact::Services::EventSpotService.new(@client).get_events()
      events.should be_kind_of(ConstantContact::Components::ResultSet)
      events.results.collect{|e| e.should be_kind_of(ConstantContact::Components::Event) }
    end
  end

  describe "#get_event" do
    it "returns an event" do
      json = load_file('event.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)
      event = ConstantContact::Services::EventSpotService.new(@client).get_event(1)

      event.should be_kind_of(ConstantContact::Components::Event)
    end
  end

  describe "#add_event" do
    it "adds an event" do
      json = load_file('event.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:post).and_return(response)
      event = ConstantContact::Components::Event.create(JSON.parse(json))
      added = ConstantContact::Services::EventSpotService.new(@client).add_event(event)

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
      response = RestClient::Response.create(hash.to_json, net_http_resp, @request)
      RestClient.stub(:patch).and_return(response)
      
      event = ConstantContact::Components::Event.create(JSON.parse(json))
      updated = ConstantContact::Services::EventSpotService.new(@client).publish_event(event)
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
      response = RestClient::Response.create(hash.to_json, net_http_resp, @request)
      RestClient.stub(:patch).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(json))
      updated = ConstantContact::Services::EventSpotService.new(@client).cancel_event(event)
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

      response =RestClient::Response.create(fees_json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)
      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      fees = ConstantContact::Services::EventSpotService.new(@client).get_fees(event)
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
      response =RestClient::Response.create(fee_json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
      retrieved = ConstantContact::Services::EventSpotService.new(@client).get_fee(event, fee)
      retrieved.should be_kind_of(ConstantContact::Components::EventFee)
    end
  end

  describe "#add_fee" do
    it "adds an event fee" do
      event_json = load_file('event.json')
      fee_json = load_file('fee.json')

      net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
      response =RestClient::Response.create(fee_json, net_http_resp, @request)
      RestClient.stub(:post).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
      added = ConstantContact::Services::EventSpotService.new(@client).add_fee(event, fee)
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
      response = RestClient::Response.create(hash.to_json, net_http_resp, @request)
      RestClient.stub(:put).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
      updated = ConstantContact::Services::EventSpotService.new(@client).update_fee(event, fee)
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
      response = RestClient::Response.create('', net_http_resp, @request)
      RestClient.stub(:delete).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      fee   = ConstantContact::Components::EventFee.create(JSON.parse(fee_json))
      expect(ConstantContact::Services::EventSpotService.new(@client).delete_fee(event, fee)).to eq true
    end
  end

  describe "#get_registrants" do
    it "returns an array of event registrants" do
      event_json = load_file('event.json')
      registrants_json = load_file('registrants.json')

      net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
      response =RestClient::Response.create(registrants_json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      registrants = ConstantContact::Services::EventSpotService.new(@client).get_registrants(event)
      registrants.should be_kind_of(ConstantContact::Components::ResultSet)
      registrants.results.collect{|r| r .should be_kind_of(ConstantContact::Components::Registrant) }
    end
  end

  describe "#get_registrant" do
    it "returns an event registrant" do
      event_json = load_file('event.json')
      registrant_json = load_file('registrant.json')

      net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
      response =RestClient::Response.create(registrant_json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      event = ConstantContact::Components::Event.create(JSON.parse(event_json))
      registrant = ConstantContact::Components::Registrant.create(JSON.parse(registrant_json))
      retrieved = ConstantContact::Services::EventSpotService.new(@client).get_registrant(event, registrant)
      retrieved.should be_kind_of(ConstantContact::Components::Registrant)
      retrieved.id.should_not be_empty
    end
  end

  describe "#get_event_items" do
    it "returns an array of event items" do
      json_response = load_file('event_items_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response =RestClient::Response.create(json_response, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      results = ConstantContact::Services::EventSpotService.new(@client).get_event_items(1)
      results.should be_kind_of(Array)
      results.first.should be_kind_of(ConstantContact::Components::EventItem)
      results.first.name.should eq('Running Belt')
    end
  end

  describe "#get_event_item" do
    it "returns an event item" do
      json = load_file('event_item_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).get_event_item(1, 1)
      result.should be_kind_of(ConstantContact::Components::EventItem)
      result.name.should eq('Running Belt')
    end
  end

  describe "#add_event_item" do
    it "adds an event item" do
      json = load_file('event_item_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:post).and_return(response)
      event_item = ConstantContact::Components::EventItem.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).add_event_item(1, event_item)
      result.should be_kind_of(ConstantContact::Components::EventItem)
      result.name.should eq('Running Belt')
    end
  end

  describe "#delete_event_item" do
    it "deletes an event item" do
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, @request)
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).delete_event_item(1, 1)
      expect(result).to eq true
    end
  end

  describe "#update_event_item" do
    it "updates an event item" do
      json = load_file('event_item_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:put).and_return(response)
      event_item = ConstantContact::Components::EventItem.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).update_event_item(1, event_item)
      result.should be_kind_of(ConstantContact::Components::EventItem)
      result.name.should eq('Running Belt')
    end
  end

  describe "#get_event_item_attributes" do
    it "returns an array of event item attributes" do
      json_response = load_file('event_item_attributes_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response =RestClient::Response.create(json_response, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      results = ConstantContact::Services::EventSpotService.new(@client).get_event_item_attributes(1, 1)
      results.should be_kind_of(Array)
      results.first.should be_kind_of(ConstantContact::Components::EventItemAttribute)
      results.first.name.should eq('Royal Blue')
    end
  end

  describe "#get_event_item_attribute" do
    it "returns an event item attribute" do
      json = load_file('event_item_attribute_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).get_event_item_attribute(1, 1, 1)
      result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
      result.name.should eq('Hi-Vis Green')
    end
  end

  describe "#add_event_item_attribute" do
    it "adds an event item attribute" do
      json = load_file('event_item_attribute_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:post).and_return(response)
      event_item_attribute = ConstantContact::Components::EventItemAttribute.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).add_event_item_attribute(1, 1, event_item_attribute)
      result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
      result.name.should eq('Hi-Vis Green')
    end
  end

  describe "#delete_event_item_attribute" do
    it "deletes an event item attribute" do
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, @request)
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).delete_event_item_attribute(1, 1, 1)
      expect(result).to eq true
    end
  end

  describe "#update_event_item_attribute" do
    it "updates an event item attribute" do
      json = load_file('event_item_attribute_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:put).and_return(response)
      event_item_attribute = ConstantContact::Components::EventItemAttribute.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).update_event_item_attribute(1, 1, event_item_attribute)
      result.should be_kind_of(ConstantContact::Components::EventItemAttribute)
      result.name.should eq('Hi-Vis Green')
    end
  end

  describe "#get_promocodes" do
    it "returns an array of promocodes" do
      json_response = load_file('promocodes_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response =RestClient::Response.create(json_response, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      results = ConstantContact::Services::EventSpotService.new(@client).get_promocodes(1)
      results.should be_kind_of(Array)
      results.first.should be_kind_of(ConstantContact::Components::Promocode)
      results.first.code_name.should eq('REDUCED_FEE')
    end
  end

  describe "#get_promocode" do
    it "returns a promocode" do
      json = load_file('promocode_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).get_promocode(1, 1)
      result.should be_kind_of(ConstantContact::Components::Promocode)
      result.code_name.should eq('TOTAL_FEE')
    end
  end

  describe "#add_promocode" do
    it "adds a promocode" do
      json = load_file('promocode_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:post).and_return(response)
      promocode = ConstantContact::Components::Promocode.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).add_promocode(1, promocode)
      result.should be_kind_of(ConstantContact::Components::Promocode)
      result.code_name.should eq('TOTAL_FEE')
    end
  end

  describe "#delete_promocode" do
    it "deletes a promocode" do
      net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

      response = RestClient::Response.create('', net_http_resp, @request)
      RestClient.stub(:delete).and_return(response)

      result = ConstantContact::Services::EventSpotService.new(@client).delete_promocode(1, 1)
      expect(result).to eq true
    end
  end

  describe "#update_promocode" do
    it "updates an event item" do
      json = load_file('promocode_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response = RestClient::Response.create(json, net_http_resp, @request)
      RestClient.stub(:put).and_return(response)
      promocode = ConstantContact::Components::Promocode.create(JSON.parse(json))

      result = ConstantContact::Services::EventSpotService.new(@client).update_promocode(1, promocode)
      result.should be_kind_of(ConstantContact::Components::Promocode)
      result.code_name.should eq('TOTAL_FEE')
    end
  end

end