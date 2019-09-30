require "openssl"
require "openssl/hmac"
require "uri"

module LibPixel
  class Client
    property host : String = ""
    property secret : String = ""
    property https : Bool = false
    property default_source : String = ""

    def initialize(@host = ENV["LIBPIXEL_HOST"], @secret = ENV["LIBPIXEL_SECRET"], @https = false, @default_source = "")
    end

    def sign(uri : String | URI)
      if secret.blank?
        raise "Your LibPixel secret must be defined (e.g. LibPixel.secret = 'SECRET')"
      end

      uri = URI.parse(uri) unless uri.is_a?(URI)

      query = uri.query
      data = uri.path
      data += "?#{query}" if query && query != ""

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA1, secret, data)

      query += "&" if query && query != ""
      query = "#{query}signature=#{signature}"

      uri.query = query

      uri.to_s
    end

    def url(path : String | Nil, options = Hash(String, (String | Int32)).new)
      if host.blank?
        raise "Your LibPixel host name must be defined (e.g. LibPixel.host = 'example.libpx.com')"
      end

      use_https = options.fetch(:https) { https }
      source = options.fetch(:source) { default_source }

      options = options.to_h
      options = options.reject { |k| k == :source }
      options = options.reject { |k| k == :https }
    
      query = options.map {|k, v| "#{k}=#{URI.encode_www_form(v.to_s)}"}.join("&")

      if query == ""
        query = nil
      end

      if source.is_a?(String) && !source.blank?
        source_clean = source.gsub(/^\//, "").gsub(/\/$/, "")
        path_clean = (path || "").gsub(/^\//, "")
        path = "/#{source_clean}/#{path_clean}"
      else
        if path.nil? || path !~ /^\//
          path = "/#{path}"
        end
      end

      uri = URI.new(
        scheme: (use_https ? "https" : "http"),
        host: host,
        path: path,
        query: query,
        fragment: nil
      )
      if secret && !secret.blank?
        sign(uri)
      else
        uri
      end
    end
  end
end
