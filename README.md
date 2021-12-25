# Deprecation Notice:
This SDK is deprecated. For alternatives, please visit [•tbk. | DEVELOPERS - Documentación](https://www.transbankdevelopers.cl/documentacion/oneclick#crear-una-inscripcion)

# Transbank::Oneclick

Ruby Implementation of Transbank Oneclick API SOAP

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transbank-oneclick'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transbank-oneclick

Run the generator:

    $ rails generate transbank_oneclick:install

## Usage

**Init Inscription**

```ruby
response = Transbank::Oneclick.init_inscription({
	email: "username@domain",
	username: "username",
	response_url: "http://domain/card"
})
 => #<Transbank::Oneclick::Response valid: true, token: "sb7068703be6aaed4660ec5c64c861a0705ad0c3104b17608d4c34dd3a32b334", url_webpay: "https://webpay3g.cl/webpayserver/bp_inscription.cgi" >
response.token
=> "sb7068703be6aaed4660ec5c64c861a0705ad0c3104b17608d4c34dd3a32b334"
response.url_webpay
=> "https://webpay3g.cl/webpayserver/bp_inscription.cgi"
 response.valid?
=> true
```

**Finish Inscription**

```ruby
response = Transbank::Oneclick.finish_inscription(tbk_token)
=> #<Transbank::Oneclick::Response valid: true, auth_code: "1415", credit_card_type: "Visa", last4_card_digits: "3792", response_code: "0", tbk_user: "e5ed4d5a-21bc-30a1-82ac-5hfa3835812p" >
response.auth_code
=> "1415"
response.credit_card_type
=> "Visa"
response.last4_card_digits
=> "3792"
response.response_code
=> "0"
response.tbk_user
=> "e5ed4d5a-21bc-30a1-82ac-5hfa3835812p"
response.valid?
=> true
```

**Remove User**

```ruby
response = Transbank::Oneclick.remove_user({
	tbk_user: "35700491-cb03-4bbb-8ab7-29dd7b0771ab",
	username: "username"
})
=> #<Transbank::Oneclick::Response valid: true, text: "true" >
response.text
=> true
response.valid?
=> true
```

**Authorize**

```ruby
response = Transbank::Oneclick.authorize({
	amount: "9990",
	tbk_user: "35700491-cb03-4bbb-8ab7-29dd7b0771ab",
	username: "username",
	buy_order: "20110715115550003"
})
=> #<Transbank::Oneclick::Response valid: true, authorization_code: "1415", credit_card_type: "Visa", last4_card_digits: "3792", response_code: "0", transaction_id: "21695" >
response.authorization_code
=> "1415"
response.credit_card_type
=> "Visa"
response.last4_card_digits
=> "3792"
response.response_code
=> "0"
response.transaction_id
=> "21695"
response.valid?
=> true
```

**Reverse**

```ruby
response = Transbank::Oneclick.reverse(buy_order)
 => #<Transbank::Oneclick::Response valid: true, reverse_code: "7597387618992517508", reversed: "true" >
response.reverse_code
=> "7597387618992517508"
response.reversed
=> "true"
response.valid?
=> true
```

**Available response methods:**


```ruby
response.valid? # true or false if any errors occurred (exceptions included)
response.errors # errors array
response.errors_display? # errors for human
response.exception? # true or false if an exception occurred
response.exception # exception object
response.attributes # hash attributes response (token, reverse_code . . .)
```

## Configuration

First, you need to set up your configuration:

`rails generate transbank_oneclick:install`

Then edit (config/initializers/transbank_oneclick.rb):

```ruby
Transbank::Oneclick.configure do |config|
  config.url               = "ONECLICK_SOAP_URL"
  config.cert_path         = "RELATIVE_PATH_TO_CRT_FILE"
  config.key_path          = "RELATIVE_PATH_TO_KEY_FILE"
  config.server_cert_path  = "RELATIVE_PATH_TO_SERVER_CRT_FILE"
end
```

**Logging**

Pass a logger object in the configuration pointing to a log file and any options you need:

```ruby
Transbank::Oneclick.configure do |config|
  config.logger = Logger.new("RELATIVE_PATH_TO_LOG_FILE")
end
```

That log file will be then written with every resulting xml from each api call, both request and response.
Note: Log level used is **info**.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/transbank-oneclick/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

transbank-oneclick is released under the [MIT License](http://www.opensource.org/licenses/MIT).
