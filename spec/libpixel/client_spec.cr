require "../spec_helper"

describe LibPixel::Client do
  Spec.before_each do
    ENV.delete("LIBPIXEL_HOST")
    ENV.delete("LIBPIXEL_SECRET")
  end

  describe ".new" do
    it "uses the LIBPIXEL_HOST environment variable as a default host" do
      ENV["LIBPIXEL_HOST"] = "env"
      ENV["LIBPIXEL_SECRET"] = "supersecret"
      client = LibPixel::Client.new
      client.host.should eq "env"
    end

    it "uses the LIBPIXEL_SECRET environment variable as a default secret" do
      ENV["LIBPIXEL_HOST"] = "env"
      ENV["LIBPIXEL_SECRET"] = "supersecret"
      client = LibPixel::Client.new
      client.secret.should eq "supersecret"
    end

    it "prefers host option over host environment variable" do
      ENV["LIBPIXEL_HOST"] = "env"
      ENV["LIBPIXEL_SECRET"] = "supersecret"
      client = LibPixel::Client.new(host: "my-host")
      client.host.should eq "my-host"
    end

    it "prefers secret option over secret environment variable" do
      ENV["LIBPIXEL_HOST"] = "env"
      ENV["LIBPIXEL_SECRET"] = "supersecret"
      client = LibPixel::Client.new(secret: "topsecret")
      client.secret.should eq "topsecret"
    end
  end

  describe "#sign" do
    it "adds the query string with the signature" do
      url = "http://test.libpx.com/images/1.jpg"
      signature = "bd5634c055d707c1638eff93eb88ff31277958f0"
      default_client.sign(url).should eq "#{url}?signature=#{signature}"
    end

    it "appends the signature to an existing query string" do
      url = "http://test.libpx.com/images/2.jpg?width=400"
      signature = "baa12c05ed279dbc623ffc8b74b183f6044e5998"
      default_client.sign(url).should eq "#{url}&signature=#{signature}"
    end

    it "ignores the '?' separator if there's no query string" do
      url = "http://test.libpx.com/images/1.jpg"
      default_client.sign(url).should eq default_client.sign("#{url}?")
    end

    it "supports URLs with a query string and a fragment" do
      default_client.sign("http://test.libpx.com/images/3.jpg?width=300&height=220#image").should eq "http://test.libpx.com/images/3.jpg?width=300&height=220&signature=500ad73bdf2d9e77d6bb94f0ca1c72f9c1f495f8#image"
    end

    it "supports URLs with a fragment but no query string" do
      default_client.sign("http://test.libpx.com/images/1.jpg#test").should eq "http://test.libpx.com/images/1.jpg?signature=bd5634c055d707c1638eff93eb88ff31277958f0#test"
    end

    it "requires the secret to be set" do
      client = default_client
      client.secret = ""
      expect_raises(Exception) do
        client.sign("http://test.libpx.com/images/1.jpg")
      end
    end
  end

  describe "#url" do
    it "constructs a URL for a given path" do
      client = default_client
      client.secret = ""
      url = "http://test.libpx.com/images/5.jpg"
      client.url("/images/5.jpg").to_s.should eq url
    end

    it "turns options into a query string" do
      client = default_client
      client.secret = ""
      url = "http://test.libpx.com/images/101.jpg?width=200&height=400"
      client.url("/images/101.jpg", { width: 200, height: 400 }).to_s.should eq url
    end

    it "uses HTTPS if the https option is set to true" do
      client = default_client
      client.secret = ""
      client.https = true
      url = "https://test.libpx.com/images/1.jpg"
      client.url("/images/1.jpg").to_s.should eq url
    end

    it "signs the request if a secret is given" do
      url = "http://test.libpx.com/images/1.jpg?width=600&signature=dfcaec7b88d53a7a932e8a6a00d10b4f9ff1336b"
      default_client.url("/images/1.jpg", { width: 600 }).to_s.should eq url
    end

    it "sets the path to '/' if nil or empty" do
      client = default_client
      client.secret = ""
      url = "http://test.libpx.com/?src=url"
      client.url("", { src: "url" }).to_s.should eq url
      client.url(nil, { src: "url" }).to_s.should eq url
    end

    # it "sets the path to '/' if the path is omitted" do
    #   url = "http://test.libpx.com/?src=url"
    #   default_client.url({ src: "url" }).to_s.should eq url
    # end

    it "requires the host to be set" do
      client = default_client
      client.host = ""

      expect_raises(Exception) do
        client.url("images/1.jpg")
      end
    end
  end
end

def default_client
  LibPixel::Client.new(
    host: "test.libpx.com",
    secret: "LibPixel",
    https: false
  )
end