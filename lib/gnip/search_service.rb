require 'base64'
require 'rest-client'
require 'yajl'

module Gnip
  class SearchException < StandardError; end
  class InvalidSearchException < StandardError; end
  class SearchService

    SEARCH_ENDPOINT = "https://search.gnip.com/accounts/#{GNIP_ACCOUNT}/search/#{GNIP_STREAM_NAME}.json"
    COUNT_ENDPOINT = "https://search.gnip.com/accounts/#{GNIP_ACCOUNT}/search/#{GNIP_STREAM_NAME}/counts.json"

    def self.activities_for(query, **args)
      data = {query: query, publisher: 'twitter', maxResults: 100}
      data[:maxResults] = args[:max] if args[:max]
      data[:fromDate], data[:toDate] = datestamp_range(args[:from], args[:to]) if args.values_at(:from, :to).all?
      response = http_post(SEARCH_ENDPOINT, Yajl::Encoder.encode(data))
      parse_activities response
    end

    def self.counts_for(query, **args)
      data = {query: query, publisher: 'twitter', bucket: 'hour'}
      data[:bucket] = args[:bucket] if args[:bucket]
      data[:fromDate], data[:toDate] = datestamp_range(args[:from], args[:to]) if args.values_at(:from, :to).all?
      response = http_post(COUNT_ENDPOINT, Yajl::Encoder.encode(data))
      parsed_counts = parse_counts(response)
      {
          point_interval: 3600000,
          point_start: DateTime.iso8601(parsed_counts.first[:timePeriod]).to_time.to_i * 1000,
          data: parsed_counts.map { |r| r[:count] }
      }
    end

    private

    def self.datestamp_range(from, to)
      from_datestamp = DateTime.iso8601(from).to_time.utc.strftime('%Y%m%d%H%M').to_i
      to_datestamp = [DateTime.iso8601(to).to_time.utc.strftime('%Y%m%d%H%M').to_i, DateTime.now.strftime('%Y%m%d%H%M').to_i].min
      [from_datestamp, to_datestamp]
    end

    def self.http_post(url, data)
      begin
        RestClient::Request.new(method: :post, url: url, user: GNIP_USERNAME, payload: data,
                                password: GNIP_PASSWORD, timeout: 30, open_timeout: 30,
                                headers: {content_type: :json, accept: :json}).execute
      rescue SocketError => se
        raise Gnip::SearchException.new("SocketError: #{se.message}")
      rescue => e
        unless e.response.nil?
          if e.response.code == 422
            raise InvalidSearchException.new parse_error(e.response)
          else
            raise SearchException.new("Search API returned HTTP #{e.response.code}.\nREQUEST:\nURL: #{url}\nPOST DATA: #{data}\nRESPONSE CODE: #{e.response.code}\nRESPONSE: #{e.response}\n")
          end
        end
      end
    end

    def self.parse_activities(json)
      parser = Yajl::Parser.new(symbolize_keys: true)
      obj = parser.parse json
      obj[:results].sort! { |a, b| b[:postedTime] <=> a[:postedTime] }
    rescue Yajl::ParseError => e
      raise Gnip::SearchException.new("Could not parse JSON from /activities: #{e.message}.\nJSON:\n#{json}\n")
    end

    def self.parse_counts(json)
      parser = Yajl::Parser.new(symbolize_keys: true)
      obj = parser.parse json
      obj[:results].sort! { |a, b| a[:postedTime] <=> b[:postedTime] }
    rescue Yajl::ParseError => e
      raise Gnip::SearchException.new("Could not parse JSON from /counts endpoint: #{e.message}.\nJSON:\n#{json}\n")
    end

    def self.parse_error(json)
      parser = Yajl::Parser.new(symbolize_keys: true)
      obj = parser.parse json
      obj[:error][:message]
    rescue Yajl::ParseError => e
      raise Gnip::SearchException.new("Could not parse error JSON: #{e.message}.\nJSON:\n#{json}\n")
    end
  end
end
