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
        @lists = []
        @contact = {
          'first_name'=> nil,
          'last_name' => nil,
          'middle_name' => nil
        }

        @email = {
          'email_address' => nil
        }

        @address = {
          'line1' => nil,
          'line2' => nil,
          'line3' => nil,
          'city' => nil,
          'state_code' => nil,
          'country_code' => nil,
          'postal_code' => nil,
          'sub_postal_code' => nil
        }

        response = @oauth.get_access_token(@code)
        @token = response['access_token']

        cc = ConstantContact::Api.new(cnf['api_key'], @token)
        lists = cc.get_lists()
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

      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the contact : " + message
      end
      erb :contact
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
      cc = ConstantContact::Api.new(cnf['api_key'], @token)

      @contact = params[:contact]
      @email = params[:email]
      @address = params[:address]
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
        if @contact
          # Validate
          raise 'Please fill in the first name' if @contact['first_name'].blank?
          raise 'Please fill in the last name' if @contact['last_name'].blank?
          raise 'Please fill in the email' if @email['email_address'].blank?
          raise 'Please select a list' if lists['checkboxes'].blank?

          @contact['email_addresses'] = []
          @contact['addresses'] = []
          @contact['lists'] = []

          if @email['email_address']
            @contact['email_addresses'] << @email
          end

          if @address
            @contact['addresses'] << @address
          end

          lists['ids'].each do |key, list_id|
            @contact['lists'] << {:id => list_id} if lists['checkboxes'][key]
          end

          response = cc.get_contact_by_email(@email['email_address']) rescue 'Resource not found'
          contact = ConstantContact::Components::Contact.create(@contact)
          if response && response.respond_to?(:results) && !response.results.empty?
            contact.id = response.results.first.id.to_s
            cc.update_contact(contact)
          else
            cc.add_contact(contact)
          end

          redirect '/cc_callback'
        end
      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the contact : " + message
        p e.backtrace
      end
      erb :contact
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