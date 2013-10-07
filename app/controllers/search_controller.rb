require "gnip/search_service"

class SearchController < ApplicationController
  rescue_from 'Gnip::InvalidSearchException' do |e|
    render text: e.message, status: :bad_request
  end

  def show
  end

  def activities
    activities = Gnip::SearchService.activities_for params[:q], from: params[:from], to: params[:to]
    render json: Yajl::Encoder.encode(activities, {html_safe?: true})
  end

  def counts
    counts = Gnip::SearchService.counts_for params[:q], from: params[:from], to: params[:to]
    render json: Yajl::Encoder.encode(counts, {html_safe?: true})
  end
end
