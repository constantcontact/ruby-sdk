  #
# oauth2_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Auth::OAuth2 do
  
  before(:all) {
    ConstantContact::Util::Config.configure do |config|
      config[:auth].delete :api_key
      config[:auth].delete :api_secret
      config[:auth].delete :redirect_uri
    end
  }
  
	describe "#new" do
		it "fails without arguments and no configuration" do
			lambda {
				ConstantContact::Auth::OAuth2.new
			}.should raise_error(ArgumentError)
		end
    
		it "takes one argument" do
			opts = {:api_key => 'api key', :api_secret => 'secret', :redirect_url => 'redirect url'}
			lambda {
				ConstantContact::Auth::OAuth2.new(opts)
			}.should_not raise_error
		end
	end

  context "with middle-ware configuration" do
    before(:all) do
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
    end
		let(:proc) { lambda { ConstantContact::Auth::OAuth2.new } }
    it "without error" do
		  proc.should_not raise_error
    end
    let(:oauth) { proc.call }
    it "has correct api_key" do
      oauth.client_id.should == "config_api_key"
    end
    it "has correct api_secret" do
      oauth.client_secret.should == "config_api_secret"
    end
    it "has correct redirect_uri" do
      oauth.redirect_uri.should == "config_redirect_uri"
    end
	end

  context "with middle-ware configuration and explicit opts" do
    before(:all) do
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
    end
		let(:proc) { lambda { ConstantContact::Auth::OAuth2.new api_key: 'explicit_api_key', api_secret: 'explicit_api_secret', redirect_url: 'explicit_redirect_uri' } }
    it "without error" do
		  proc.should_not raise_error
    end
    let(:oauth) { proc.call }
    it "has correct api_key" do
      oauth.client_id.should == "explicit_api_key"
    end
    it "has correct api_secret" do
      oauth.client_secret.should == "explicit_api_secret"
    end
    it "has correct redirect_uri" do
      oauth.redirect_uri.should == "explicit_redirect_uri"
    end
	end

	it "with explicit arguments and no configuration" do
		lambda {
			ConstantContact::Auth::OAuth2.new  api_key: "api_key", api_secret: "api_secret", redirect_uri: "redirect_uri" 
		}.should raise_error(ArgumentError)
	end


	describe "#get_authorization_url" do
		before(:each) do
			opts = {:api_key => 'api key', :api_secret => 'secret', :redirect_url => 'redirect url'}
			@auth = ConstantContact::Auth::OAuth2.new(opts)
		end

		it "returns a string" do
			@auth.get_authorization_url.should be_kind_of(String)
		end
	end

	describe "#get_access_token" do
		before(:each) do
			opts = {:api_key => 'api key', :api_secret => 'secret', :redirect_url => 'redirect url'}
			@auth = ConstantContact::Auth::OAuth2.new(opts)
		end

		it "returns a Hash" do
			json = load_json('access_token.json')
			RestClient.stub(:post).and_return(json)
			@auth.get_access_token('token').should be_kind_of(Hash)
		end
	end
end