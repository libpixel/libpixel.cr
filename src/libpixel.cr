require "./libpixel/version"
require "./libpixel/client"

module LibPixel

  def self.default_client
    @@default_client ||= Client.new
  end

  def self.setup
    yield default_client
  end

  def self.host=(host : String)
    default_client.host = host
  end

  def self.secret=(secret : String)
    default_client.secret = secret
  end

  def self.https=(https : Bool)
    default_client.https = https
  end

  def self.default_source=(source : String)
    default_client.default_source = source
  end

  def self.sign(uri : (String | URI))
    default_client.sign(uri)
  end

  def self.url(path : String | Nil, options = Hash(String, (String | Int32)).new)
    default_client.url(path, options)
  end
end