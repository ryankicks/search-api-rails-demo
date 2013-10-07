require 'vcr'
require 'vcr_helper'
require_relative '../../lib/gnip/search_service'

describe Gnip::SearchService do
  describe '.activities_for' do
    it 'retrieves tweets matching the search term' do
      VCR.use_cassette('activities-obama') do
        activities = Gnip::SearchService.activities_for 'obama'
        activities.should_not be_nil
      end
    end
  end

  describe '.counts_for' do
    it 'retrieves a trend of tweet counts by day' do
      VCR.use_cassette('counts-obama') do
        counts = Gnip::SearchService.counts_for 'obama', from: DateTime.new(2013, 9, 9).rfc3339, to: DateTime.new(2013, 9, 27).rfc3339
        counts[:point_interval].should == 3600000
        Time.at(counts[:point_start] / 1000).utc.strftime('%Y%m%d%H').should == '2013090900'
        counts[:data].is_a?(Array).should be_true
        counts[:data].first.should == 11552
        counts[:data].last.should == 8991
      end
    end

    it 'propagates HTTP errors' do
      VCR.use_cassette('counts-http-fail') do
        invocation = -> { Gnip::SearchService.counts_for('gnip') }
        invocation.should raise_error(Gnip::SearchException)
      end
    end
  end
end
