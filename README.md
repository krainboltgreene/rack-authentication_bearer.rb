# rack/authentication_bearer

  - [![Build](http://img.shields.io/travis-ci/krainboltgreene/rack-authentication_bearer.gem.svg?style=flat-square)](https://travis-ci.org/krainboltgreene/rack-authentication_bearer.gem)
  - [![Dependencies](http://img.shields.io/gemnasium/krainboltgreene/rack-authentication_bearer.gem.svg?style=flat-square)](https://gemnasium.com/krainboltgreene/rack-authentication_bearer.gem)
  - [![Version](http://img.shields.io/gem/v/rack-authentication_bearer.svg?style=flat-square)](https://rubygems.org/gems/rack-authentication_bearer)

A middleware for parsing [Bearer tokens](https://tools.ietf.org/html/rfc6750#section-2.1) from the HTTP request header `Authentication` (or `Authorization` if you're old school).


## Using

This gem just provides you an easy way to take the header value and turn it into something meaningful for your rack-based application. This is largely helpful for things like PEST or JWT ([though](https://news.ycombinator.com/item?id=14727453) [we](https://news.ycombinator.com/item?id=14292223) [think](https://paragonie.com/blog/2017/03/jwt-json-web-tokens-is-bad-standard-that-everyone-should-avoid) [it's](http://cryto.net/~joepie91/blog/2016/06/13/stop-using-jwt-for-sessions/) [a](http://cryto.net/~joepie91/blog/2016/06/19/stop-using-jwt-for-sessions-part-2-why-your-solution-doesnt-work/) [bad](https://kev.inburke.com/kevin/things-to-use-instead-of-jwt/) [idea](https://news.ycombinator.com/item?id=16070588)). So lets talk about what we can do:

First, if you don't want to care at all just don't provide a proc:

``` ruby
rack.use(Rack::AuthenticationBearer)
```

The middleware will do nothing! This is valuable for certain environments. Okay, so here is an example of simple token decoding:

``` ruby
rack.use(
  Rack::AuthenticationBearer,
  -> (bearer) do
    Base64.urlsafe_decode64(value)
  end
)
```

This will take a header like `Authentication: Bearer VGhpcyBJcyBBIFNlY3JldA==` and returns `"This Is A Secret"`, which you will have access to in your rack env `rack.authentication`. Now a little more complex JWT version:


``` ruby
rack.use(
  Rack::AuthenticationBearer,
  -> (bearer) do
    begin
      JWT.decode(token, SOMESECRET).first
    rescue JWT::DecodeError
      {}
    end
  end
)
```

Okay, so what happens if the client is sending a malformed authentication value? Well, we don't freak out, instead we give you the tools to freak out:

``` ruby
rack.call({"HTTP_AUTHORIZATION" => "Bearer "})
# {
#   "HTTP_AUTHORIZATION" => "Bearer ",
#   "rack.authentication" => Rack::AuthenticationBearer::InvalidBearerTokenError
# }
```

Okay, now what if they don't have a value at all?

``` ruby
rack.call({})
# {
#   "rack.authentication" => Rack::AuthenticationBearer::MissingBearerTokenError
# }
```

These exception classes have a `status` property that you can bubble up to the server.


## Installing

Add this line to your application's Gemfile:

    gem "rack-authentication_bearer", "~> 2.0"

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install rack-authentication_bearer


## Contributing

  1. Fork it
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create new Pull Request


## Licensing

Copyright (c) 2018 Kurtis Rainbolt-Greene

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
