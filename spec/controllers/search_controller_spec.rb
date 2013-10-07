require 'spec_helper'

describe SearchController do
  describe 'GET #show' do
    it 'renders the :show template successfully' do
      get :show
      assert_response :success
      assert_template :show
    end
  end

  context 'given a fake search service' do
    let(:expected_activity_data) { { 'data' => 'activities' } }
    let(:expected_counts_data) { { 'data' => 'count stuff' } }

    before do
      Gnip::SearchService.stub(activities_for: expected_activity_data, counts_for: expected_counts_data)
    end

    describe 'post #activities' do
      it 'return JSON activities from the search service' do
        post :activities
        assert_response :success
        JSON.parse(@response.body).should == expected_activity_data
      end
    end

    describe 'post #counts' do
      it 'return JSON activities from the search service' do
        post :counts
        assert_response :success
        JSON.parse(@response.body).should == expected_counts_data
      end
    end
  end
end
