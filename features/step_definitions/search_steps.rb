require_relative '../../lib/gnip/search_service'

When(/^I search for (.*)$/) do |term|
  @counts ||= {}
  @activities ||= {}
  VCR.use_cassette("counts-#{term}") do
    @counts[term] = Gnip::SearchService.counts_for(term)
  end
  VCR.use_cassette("activities-#{term}") do
    @activities[term] = Gnip::SearchService.activities_for(term)
  end
end

Then(/^the application retrieves activities containing (.*)$/) do |term|
  @activities[term].is_a?(Array).should be_true
  @activities[term].size.should == 100
  @activities[term].first[:body].downcase.include?(term).should be_true
end

Then(/^the application retrieves counts for (.*)$/) do |term|
  @counts[term][:data].is_a?(Array).should be_true
  @counts[term][:data].first.is_a?(Fixnum).should be_true
  @counts[term][:point_start].is_a?(Fixnum).should be_true
  @counts[term][:point_interval].is_a?(Fixnum).should be_true
end
