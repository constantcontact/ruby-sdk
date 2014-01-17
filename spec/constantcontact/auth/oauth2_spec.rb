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
    let(:proc) { lambda { ConstantContact::Auth::OAuth2.new :api_key => 'explicit_api_key', :api_secret => 'explicit_api_secret', :redirect_url => 'explicit_redirect_uri' } }
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
      ConstantContact::Auth::OAuth2.new  :api_key => "api_key", :api_secret => "api_secret", :redirect_url => "redirect_uri"
    }.should_not raise_error
  end

  let(:proc) { lambda { ConstantContact::Auth::OAuth2.new(:api_key => "api_key", :api_secret => "api_secret", :redirect_url => "redirect_uri") } }
  let(:oauth) { proc.call }

  describe "#get_authorization_url" do
    it "returns a string" do
      oauth.get_authorization_url.should be_kind_of(String)
      oauth.get_authorization_url(true, 'my_param').should match('state=my_param')
    end
  end

  describe "#get_access_token" do
    it "returns a Hash" do
      json = load_file('access_token.json')
      RestClient.stub(:post).and_return(json)
      oauth.get_access_token('token').should be_kind_of(Hash)
    end

    it "throws an OAuth2Exception in case of error" do
      json = load_file('access_token_error.json')
      RestClient.stub(:post).and_return(json)
      lambda {
        oauth.get_access_token('token')
      }.should raise_exception(ConstantContact::Exceptions::OAuth2Exception, 
        'The resource owner or authorization server denied the request.')
    end
  end

  describe "#get_token_info" do
    it "returns a Hash" do
      json = load_file('token_info.json')
      RestClient.stub(:post).and_return(json)
      info = oauth.get_token_info('token')
      info.should be_kind_of(Hash)
      info['user_name'].should eq('ctcttest')
    end
  end

end