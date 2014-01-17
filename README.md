Constant Contact Ruby SDK
=========================

[![Build Status](https://travis-ci.org/constantcontact/ruby-sdk.png)](https://travis-ci.org/constantcontact/ruby-sdk)

In order to use the Constant Contact SDK you have to follow these steps:

A. Rails example :

1. Install the gem :

        gem install constantcontact

2. Configure Rails to load the gem :

        Rails::Initializer.run do |config|
            ...
            config.gem "constantcontact"
            ...
        end
        
or add the following in your .Gemfile :

        gem 'constantcontact'

3. Create a new action and add the following code:

        @oauth = ConstantContact::Auth::OAuth2.new(
            :api_key => 'your api key',
            :api_secret => 'your secret key',
            :redirect_url => 'your redirect url'
        )

        @error = params[:error]
        @user = params[:username]
        @code = params[:code]

        if @code
            response = @oauth.get_access_token(@code)
            if response
                token = response['access_token']
                cc = ConstantContact::Api.new('your api key')
                @contacts = cc.get_contacts(token)
            end
        end


    Note: 'your redirect url' is the URL of the action you just created.

4. Create a view for the above mentioned action with the following code:

        <% if @error %>
            <p>
                <%=@error%>
            </p>
        <% end %>

        <% if @code %>
            <% if @contacts %>
                <% for contact in @contacts %>
                    <p>
                        Contact name: <%= contact.first_name + contact.last_name %>
                    </p>
                <% end %>
            <% end %>
        <% else %>
            <a href="<%=@oauth.get_authorization_url%>">Click to authorize</a>
        <% end %>

5. The first time you access the action in browser you should see the "Click to authorize" link.
Follow the link, go through all the Constant Contact steps required 
and then you will be redirected back to your action and you should see the list of contacts.


6. Add config initializer (optional)
````ruby
    ConstantContact::Util::Config.configure do |config|
      config[:auth][:api_key] = 'foobar'
      config[:auth][:api_secret] = 'foobar'
    end

B. Sinatra example :


1. Install the gem :

        gem install constantcontact

2. Add the following code in myapp.rb (just an example):
        require 'active_support'
        require 'constantcontact'

        get '/my_url' do
            @oauth = ConstantContact::Auth::OAuth2.new(
                :api_key => 'your api key',
                :api_secret => 'your secret key',
                :redirect_url => 'your redirect url'
            )

            @error = params[:error]
            @user = params[:username]
            @code = params[:code]

            if @code
                response = @oauth.get_access_token(@code)
                if response
                    token = response['access_token']
                    cc = ConstantContact::Api.new('your api key')
                    @contacts = cc.get_contacts(token)
                end
            end

            erb :my_view
        end


    Note: 'your redirect url' is the URL of the route you just created ( get '/my_url' ).

4. Create a my_view.rhtml (or my_view.erb) with the following code:

        <% if @error %>
            <p>
                <%=@error%>
            </p>
        <% end %>

        <% if @code %>
            <% if @contacts %>
                <% for contact in @contacts %>
                    <p>
                        Contact name: <%= contact.first_name + contact.last_name %>
                    </p>
                <% end %>
            <% end %>
        <% else %>
            <a href="<%=@oauth.get_authorization_url%>">Click to authorize</a>
        <% end %>

5. The first time you access the action in browser you should see the "Click to authorize" link.
Follow the link, go through all the Constant Contact steps required 
and then you will be redirected back to your action and you should see the list of contacts.