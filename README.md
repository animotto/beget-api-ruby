# Beget API wrapper

Simple wrapper for [API](https://beget.com/ru/kb/api/beget-api) of hosting provider [Beget](https://beget.com)

# Installation

Add this line to your Gemfile:

    gem 'beget_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beget_api

# How to use it

Create a new instance:

    api = Beget::API.new("mylogin", "mysecretpassword")

You can invoke any method in any section with the specified parameters:

    api.mysql.addDb(suffix: "test", password: "strongpassword")
    api.mysql.getList

It returns deserialized JSON data as is:

    irb(main):004:0> pp api.site.getList
    [{"id"=>12345,
      "path"=>"site.com/public_html",
      "domains"=>
        [{"id"=>12345,
          "fqdn"=>"site.com",
          "php_version"=>"7.4",
          "http_version"=>1,
          "ssl"=>false,
          "ssl_status"=>"none",
          "nginx_template"=>"default",
          "redis_session"=>false}]}]

There are exceptions that can be arise:

* HTTPError - HTTP server responds with a non success code
* RequestError - General method invoke error
* AnswerError - Answer error

The RequestError and AnswerError exceptions have the attributes "code" and "text" that describe the error.

# License

See LICENSE file

