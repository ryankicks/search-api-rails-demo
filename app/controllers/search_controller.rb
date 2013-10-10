require "gnip/search_service"

class SearchController < ApplicationController
  rescue_from 'Gnip::InvalidSearchException' do |e|
    render text: e.message, status: :bad_request
  end

  def show
  end

  def activities
    render_json get_search_results('activities_for', params)
  end

  def counts
    render_json get_search_results('counts_for', params)
  end

  private

  def get_search_results method_name, params
    Gnip::SearchService.send method_name, params[:q], from: params[:from], to: params[:to]
  end

  def render_json hash
    render json: Yajl::Encoder.encode(hash, {html_safe?: true})
  end
end
