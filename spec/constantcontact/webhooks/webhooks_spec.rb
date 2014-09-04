#
# webhooks_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Webhooks do
  describe "test methods" do
    before(:each) do
      @webhooks = ConstantContact::WebhooksUtil.new('api-secret-key')
    end

    describe "#billing_change_notification" do
      it "gets the BillingChangeNotification model object" do
        hmac_header = 'VNfTwVDbHBoPqEYqDdM61OqxJdVznRzT4h21+BuwgTg='
        json_body = load_file('billing_change_notification_request.json')

        model = @webhooks.get_billing_change_notification(hmac_header, json_body)
        model.should be_kind_of(ConstantContact::Webhooks::Models::BillingChangeNotification)
        model.event_type.should eq('tier.increase')
      end
    end
  end
end