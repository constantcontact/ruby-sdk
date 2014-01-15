#
# myapp.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'rubygems'
require 'sinatra'
require 'active_support'
require 'yaml'
require 'constantcontact'

# This is a Sinatra application (http://www.sinatrarb.com/).
# Update config.yml with your data before running the application.
# Run this application like this : ruby myapp.rb

# Name this action according to your 
# Constant Contact API Redirect URL, see config.yml
get '/cc_callback' do
    cnf = YAML::load(File.open('config/config.yml'))

    @oauth = ConstantContact::Auth::OAuth2.new(
      :api_key => cnf['api_key'],
      :api_secret => cnf['api_secret'],
      :redirect_url => cnf['redirect_url']
    )

    @error = params[:error]
    @user = params[:username]
    @code = params[:code]

    if @code
      begin
        response = @oauth.get_access_token(@code)
        @token = response['access_token']

        cc = ConstantContact::Api.new(cnf['api_key'])

        @campaign = {
          'name'=> nil,
          'subject' => nil,
          'from_name' => nil,
          'from_email' => nil,
          'reply_to_email' => nil
        }

        @message = {
          'organization_name' => nil,
          'address_line_1' => nil,
          'address_line_2' => nil,
          'address_line_3' => nil,
          'city' => nil,
          'state' => nil,
          'international_state' => nil,
          'country' => nil,
          'postal_code' => nil
        }

        @schedule = {
          'scheduled_date' => nil
        }

        @lists = []
        lists = cc.get_lists(@token)
        if lists
          lists.each do |list|
            # Select the first list, by default
            selected = list == lists.first
            @lists << {
              'id' => list.id,
              'name' => list.name,
              'selected' => selected
            }
          end
        end

        response = cc.get_verified_email_addresses(@token) rescue 'Resource not found'
        if response
          verified_email = response.first.email_address
          @campaign['from_email'] = verified_email
          @campaign['reply_to_email'] = verified_email
        end

      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the campaign : " + message
        #y e.backtrace
      end
      erb :campaign
    else
      erb :callback
    end
end


# Name this action according to your
# Constant Contact API Redirect URL, see config.yml
post '/cc_callback' do
    cnf = YAML::load(File.open('config/config.yml'))

    @error = params[:error]
    @user = params[:username]
    @code = params[:code]
    @token = params[:token]

    if @code
      cc = ConstantContact::Api.new(cnf['api_key'])

      @campaign = params[:campaign]
      @message = params[:message]
      @schedule = params[:schedule]
      lists = params[:lists] || {}
      lists['checkboxes'] = [] if lists['checkboxes'].blank?

      @lists = []
      if lists['ids']
        lists['ids'].each do |key, list_id|
          list_name = lists['names'][key]
          selected = !(lists['checkboxes'].blank? || lists['checkboxes'][key].blank?)
          @lists << {
            'id' => list_id,
            'name' => list_name,
            'selected' => selected
          }
        end
      end

      begin
        if @campaign
          # Validate
          raise 'Please fill in the name' if @campaign['name'].blank?
          raise 'Please fill in the subject' if @campaign['subject'].blank?
          raise 'Please fill in the from name' if @campaign['from_name'].blank?
          raise 'Please fill in the from email address' if @campaign['from_email'].blank?
          raise 'Please fill in the reply-to email address' if @campaign['reply_to_email'].blank?
          raise 'Please fill in the greeting string' if @campaign['greeting_string'].blank?
          raise 'Please fill in the text content' if @campaign['text_content'].blank?
          raise 'Please fill in the email content' if @campaign['email_content'].blank?
          raise 'Please select a list' if lists['checkboxes'].blank?

          if @message && !(@message['address_line_1'] || @message['city'] || @message['country']).blank?
            @campaign['message_footer'] = @message
          end

          @campaign['sent_to_contact_lists'] = []
          lists['ids'].each do |key, list_id|
            @campaign['sent_to_contact_lists'] << {:id => list_id} if lists['checkboxes'][key]
          end

          campaign = ConstantContact::Components::Campaign.create(@campaign)
          campaign = cc.add_email_campaign(@token, campaign)
          if campaign && !@schedule['scheduled_date'].blank?
            schedule = ConstantContact::Components::Schedule.create(@schedule)
            cc.add_email_campaign_schedule(@token, campaign, schedule)
          end
          redirect '/cc_callback'
        end
      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the campaign : " + message
      end
      erb :campaign
    else
      erb :callback
    end
end


def parse_exception(e)
  if e.respond_to?(:response)
    hash_error = JSON.parse(e.response)
    message = hash_error.first['error_message']
  else
    message = e.message
  end
  message.to_s
end