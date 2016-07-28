require 'rest_client'
require 'multi_json'

require "hyperwallet/version"

require "hyperwallet/hyperwallet_error"
require "hyperwallet/util"

require "hyperwallet/hyperwallet_object"
require "hyperwallet/user"
require "hyperwallet/payment"

module Hyperwallet
  API_BASE = ENV['HYPERWALLET_API_BASE'] || "https://uat.paylution.com"

  class << self
    attr_accessor :api_user, :api_password
  end

  def self.api_url(operation='', api_version = 3)
    "#{Hyperwallet::API_BASE}/rest/v#{api_version}#{operation}"
  end

  def self.request(method, url, params = {}, headers = {}, api_version = 3)
    http_method = method.to_s.downcase.to_sym
    case http_method
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      payload = params.is_a?(String) ? params : uri_encode(params)
      if http_method == :post
        payload = params.to_json
        headers[:content_type] ||= "application/json"
      end
    end

    request_opts = {
      :headers => headers,
      :method => method,
      :verify_ssl => false,
      :url  => api_url(url, api_version),
      :user => api_user,
      :password => api_password,
      :payload => payload
    }
    begin
      response = execute_request(request_opts)
      handle_api_error(response.code, response.body) unless response.code == 200
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code && rbody = e.http_body
        handle_api_error(rcode, rbody)
      else
        raise
      end
    end

    parse(response)
  end

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  def self.handle_api_error(rcode, rbody)
    case rcode
    when 400, 404
      raise InvalidRequestError.new("Your request is invalid: #{rbody.inspect}", rcode, rbody)
    when 401
      raise AuthenticationError.new("Your API user or password is invalid: #{rbody.inspect}", rcode, rbody)
    else
      raise APIError.new("API Error: #{rbody.inspect}", rcode, rbody)
    end
  end

  def self.parse(response)
    begin
      response = MultiJson.load(response.body)
    rescue MultiJson::DecodeError
      raise APIError.new("Invalid response from the API: #{response.body.inspect}")
    end
  end

  private

  def self.uri_encode(params)
    params.map { |k,v| "#{k}=#{URI.escape(v)}" }.join("&")
  end

end
