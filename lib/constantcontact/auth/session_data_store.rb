#
# session_data_store.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Auth
    class Session
      attr_accessor :session

      # Create and initialize the session
      def initialize
        cgi = CGI.new('html4')

        # We make sure to delete an old session if one exists,
        # not just to free resources, but to prevent the session
        # from being maliciously hijacked later on.
        begin
          @session = CGI::Session.new(cgi, 'database_manager' => CGI::Session::PStore, 'new_session' => false)
          @session.delete
        rescue ArgumentError # if no old session
        end
        @session = CGI::Session.new(cgi, 'database_manager' => CGI::Session::PStore, 'new_session' => true)
        @session['datastore'] = {}
      end

      # Add a new user to the data store
      # @param [String] username - Constant Contact username
      # @param [Hash] params - additional parameters
      # @return
      def add_user(username, params)
        @session['datastore'][username] = params
      end

      # Get an existing user from the data store
      # @param [String] username - Constant Contact username key
      # @return [String] The username value
      def get_user(username)
        @session['datastore'].has_key?(username) ? @session['datastore'][username] : false
      end

      # Update an existing user in the data store
      # @param [String] username - Constant Contact username
      # @param [Hash] params - additional parameters
      # @return
      def update_user(username, params)
        if @session['datastore'].has_key?(username)
          @session['datastore'][username] = params
        end
      end

      # Delete an existing user from the data store
      # @param [String] username - Constant Contact username
      # @return
      def delete_user(username)
        @session['datastore'][username] = nil
      end

      # Close current session
      # @return
      def close
        @session.close
      end

    end
  end
end

