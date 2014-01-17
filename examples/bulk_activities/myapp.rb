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

        response = @oauth.get_access_token(@code)
        @token = response['access_token']

        cc = ConstantContact::Api.new(cnf['api_key'])
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

      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the contacts : " + message
      end
      erb :contacts_multipart
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

      @activity = params[:activity]
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
        if @activity
          # Validate
          raise 'Please select a file' if @activity['file'].blank?
          file_name = @activity['file'][:filename]
          contents = @activity['file'][:tempfile].read

          add_to_lists = []
          lists['ids'].each do |key, list_id|
            add_to_lists << list_id if lists['checkboxes'][key]
          end
          add_to_lists = add_to_lists.join(',')

          if /remove_contacts/.match(file_name)
            cc.add_remove_contacts_from_lists_activity_from_file(@token, file_name, contents, add_to_lists)
          elsif /add_contacts/.match(file_name)
            cc.add_create_contacts_activity_from_file(@token, file_name, contents, add_to_lists)
          end

          redirect '/cc_callback'
        end
      rescue => e
        message = parse_exception(e)
        @error = "An error occured when saving the contacts : " + message
        #puts e.backtrace
      end
      erb :contacts_multipart
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