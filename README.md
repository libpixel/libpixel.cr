# LibPixel

[![Build Status](https://travis-ci.org/libpixel/libpixel.cr.svg?branch=master)](https://travis-ci.org/libpixel/libpixel.cr)

Crystal library to generate and sign LibPixel URLs.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     libpixel.cr:
       github: libpixel/libpixel.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "libpixel.cr"
```

Configure the LibPixel client:

```ruby
LibPixel.setup do |config|
  config.host = "test.libpx.com" # Your LibPixel domain. Required.
  config.https = true # Generates HTTPS URLs. Optional. Default is false.
  config.secret = "..." # Auth secret for your LibPixel account. Required for signing requests.
  config.default_source = "us-east-1/source" # optional source to be used, can be overriden
end
```

The configuration for host and secret will be automatically set from the environment variables `LIBPIXEL_HOST` and `LIBPIXEL_SECRET` if they are present.

### Sign URLs

You can sign an existing URL using the `sign` function:

```ruby
url = LibPixel.sign("http://test.libpx.com/images/1.jpg?width=400")
```

### Generate URLs

You can also generate and sign URLs at the same time with the `url` function:

```ruby
url = LibPixel.url("/us-east-1/images/1.jpg", height: 400, blur: 20, saturation: -80)
```

If you're using the `src` parameter, you can skip the path:

```ruby
url = LibPixel.url(src: "http://...", width: 300)
```

But even simpler, if the library sees a url beginning with http or https it knows what to do:

```ruby
url = LibPixel.url("http://...", width: 300)
```

You can specify whether you what an http or https url in your call:

```ruby
url = LibPixel.url("/us-east-1/images/1.jpg", height: 400, blur: 20, saturation: -80, https: true)
```

If you are using a default_source, you don't need to specify it in the path:

```ruby
url = LibPixel.url("1.jpg", height: 400, blur: 20, saturation: -80)
```

But you can override it with the source parameter:

```ruby
url = LibPixel.url("1.jpg", height: 400, blur: 20, saturation: -80, source: "us-west-1/source2")
```

### Multiple clients

It's also possible to have multiple instances of LibPixel clients (e.g. when dealing with multiple accounts):

```ruby
client = LibPixel::Client.new(host: "test.libpx.com", https: true, secret: "...")
```

You may then call the `#url` and `#sign` methods on the client object.


## License

[MIT](LICENSE)


## Contributors

- [Lauri Jutila](https://github.com/ljuti) - creator and maintainer
