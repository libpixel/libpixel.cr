ENV["LIBPIXEL_HOST"] = "dummy.libpixel.com"
ENV["LIBPIXEL_SECRET"] = "supersecret"

require "./spec_helper"
require "../src/libpixel"

describe LibPixel do
  describe ".setup" do
    it "sets up the default client" do
      LibPixel.setup do |config|
        config.host = "test.libpx.com"
        config.secret = "LibPixel"
      end

      LibPixel.default_client.should be_a LibPixel::Client
      LibPixel.default_client.host.should eq "test.libpx.com"
      LibPixel.default_client.secret.should eq "LibPixel"
    end
  end

  describe ".sign(uri)" do
    it "signs URIs" do
      url = "http://test.libpx.com/images/1.jpg"
      signature = "bd5634c055d707c1638eff93eb88ff31277958f0"
      LibPixel.sign(url).should eq "#{url}?signature=#{signature}"
    end
  end

  describe ".url(path)" do
    LibPixel.host = "test.libpx.com"
    LibPixel.secret = ""
    url = "http://test.libpx.com/images/5.jpg"
    LibPixel.url("/images/5.jpg").to_s.should eq url
  end
end