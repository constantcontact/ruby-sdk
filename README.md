Constant Contact Ruby SDK for AppConnect
====

The Ruby SDK for AppConnect allows you to leverage the AppConnect v2 APIs.

[![Build Status](https://travis-ci.org/constantcontact/ruby-sdk.png)](https://travis-ci.org/constantcontact/ruby-sdk)

Requirements
====
The Constant Contact Ruby SDK requires Ruby 2.2+.

Installation
====
Via bundler:
```ruby
gem 'constantcontact', '~> 4.1.0'
```
Otherwise:
```bash
[sudo|rvm] gem install constantcontact
```

Configuration
====
The AppConnect SDK can be configured with some options globally or they can be specified when creating the API client:
```ruby
ConstantContact::Util::Config.configure do |config|
  config[:auth][:api_key] = 'your-access-key'
  config[:auth][:api_secret] = 'your-access-secret'
  config[:auth][:redirect_uri] = 'https://example.com/auth/constantcontact'
end
```        

Documentation
=====
SDK Documentation is hosted at http://constantcontact.github.io/ruby-sdk

API Documentation is located at http://developer.constantcontact.com/docs/developer-guides/api-documentation-index.html

Getting Started
====
AppConnect requires an OAuth access token which will give your app access to Constant Contact data and services for the accout that granted that access token.

Rails
=====
Create a new controller action.  The redirect_url should be the same as the one given when registering the app with Mashery. Use the following code snippet to get an access token:
```ruby
@oauth = ConstantContact::Auth::OAuth2.new(
  :api_key => 'your api key',
  :api_secret => 'your secret key',
  :redirect_url => 'your redirect url' # the URL given when registering your app with Mashery.
)

@error = params[:error]
@user = params[:username]
@code = params[:code]

if @code.present?
  response = @oauth.get_access_token(@code)
  if response.present?
    token = response['access_token']
    cc = ConstantContact::Api.new('your api key', token)
    @contacts = cc.get_contacts()
  end
else
  # if not code param is provided redirect into the OAuth flow
  redirect_to @oauth.get_authorization_url and return
end
```

Create a view for the above mentioned action with the following code:
```erb

<% if @error %>
  <p><%= @error %></p>
<% end %>

<% if @contacts.present? %>
  <% @contacts.results.each do |contact| %>
    <p>Contact name: <%= "#{contact.first_name} #{contact.last_name}" %></p>
  <% end %>
<% end %>
```

The first time you access the action you will be redirected into the Constant Contact OAuth flow.
Then you will be redirected back to your action and you should see the list of contacts.

Sinatra
=====
Require AppConnect:
```ruby
require 'constantcontact'
```

Add the following route.  The redirect_url should be the same given when registering the app with Mashery.
```ruby
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
      cc = ConstantContact::Api.new('your api key', token)
      @contacts = cc.get_contacts()
    end
  end

  erb :my_view
end
```

Create a my_view.erb with the following code:
```ruby
<% if @error %>
  <p><%=@error%></p>
<% end %>

<% if @code %>
  <% if @contacts %>
    <% @contacts.results.each do |contact| %>
      <p>\Contact name: <%= "#{contact.first_name} #{contact.last_name}" %></p>
    <% end %>
  <% end %>
<% else %>
  <a href="<%=@oauth.get_authorization_url%>">Click to authorize</a>
<% end %>
```

The first time you access the action in browser you should see the "Click to authorize" link.
Follow the link, go through all the Constant Contact steps required 
and then you will be redirected back to your action and you should see the list of contacts.

Example
=====
Add a new contact using the Ruby SDK
```
#gem install constantcontact

require 'yaml' 
require 'constantcontact'

class ContactExample

  def initialize()
    cnf = YAML::load(File.open('config/config.yml'))
    @cc = ConstantContact::Api.new(cnf['api_key'], cnf['oauth_token'])
  end

  def add_contact( contact_json )
    @cc.add_contact( contact_json ) 
  end

  def get_lists
    @cc.get_lists()
  end

end
class AddContactTest
  def do()
    contact_example = ContactExample.new
    contact_list = contact_example.get_lists[0].id
    puts "Add what email address?"
    email_address = gets.chomp
    puts "Adding #{email_address} to Contact List #{contact_list}" 

    list_to_add_to = ConstantContact::Components::ContactList.new
    list_to_add_to.id = contact_list

    new_contact = ConstantContact::Components::Contact.new
    new_contact.add_email(ConstantContact::Components::EmailAddress.new(email_address))
    new_contact.add_list(list_to_add_to)
    new_contact.first_name = 'Example'
    new_contact.last_name = 'User'

    #input = "{ 'email_addresses':[{'email_address':'#{email_address}'}], 'lists':[{'id':'#{contact_list}'}], first_name':'Example', 'last_name':'User'}"
    #puts input
    puts new_contact.to_json

    puts contact_example.add_contact( new_contact ).to_json

  rescue RestClient::BadRequest => e
    puts "#{e.http_code} - #{e.http_body}"
  end
end
AddContactTest.new.do
```
