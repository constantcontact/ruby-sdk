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
        @folders = []

        response = @oauth.get_access_token(@code)
        @token = response['access_token']

        cc = ConstantContact::Api.new(cnf['api_key'])
        folders = cc.get_library_folders(@token).results
        if folders
          folders.each do |folder|
            # Select the first folder, by default
            selected = folder == folders.first
            @folders << {
              'id' => folder.id,
              'name' => folder.name,
              'selected' => selected
            }
          end
        end

      rescue => e
        message = parse_exception(e)
        @error = "An error occured when uploading the file : " + message
      end
      erb :library_multipart
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

      @library = params[:library]
      folders = params[:folders] || {}
      folders['checkboxes'] = [] if folders['checkboxes'].blank?

      @folders = []
      if folders['ids']
        folders['ids'].each do |key, folder_id|
          folder_name = folders['names'][key]
          selected = !(folders['checkboxes'].blank? || folders['checkboxes'][key].blank?)
          @folders << {
            'id' => folder_id,
            'name' => folder_name,
            'selected' => selected
          }
        end
      end

      begin
        if @library
          # Validate
          raise 'Please select a file' if @library['file'].blank?
          file_name = @library['file'][:filename]
          description = 'Example of multipart file upload'
          source = 'MyComputer'
          file_type = File.extname(file_name)[1..-1].upcase
          contents = @library['file'][:tempfile].read

          add_to_folders = []
          folders['ids'].each do |key, folder_id|
            add_to_folders << folder_id if folders['checkboxes'][key]
          end
          add_to_folders = add_to_folders.join(',')

          file_id = cc.add_library_file(@token, file_name, add_to_folders, description, source, file_type, contents)

          if file_id
            statuses = cc.get_library_files_upload_status(@token, file_id)
            response = statuses.first
            @error = "File was successfully uploaded : ID=#{response.file_id}, status=#{response.status} and description=#{response.description}"
          else
            @error = "Could not upload the file."
          end
        end
      rescue => e
        message = parse_exception(e)
        @error = "An error occured when uploading the file : " + message
      end
      erb :library_multipart
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