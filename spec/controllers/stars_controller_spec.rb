# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe StarsController, type: :controller do
  subject(:go!) { get :index, params:, format: :json }

  describe 'GET :index' do
    let(:body) { JSON.parse(response.body) }

    before do
      go!
    end

    context 'when username is missing' do
      context 'when nil' do
        let(:params) {}

        it 'returns error' do
          expect(body['success']).to be_falsey
        end

        it 'returns a message' do
          expect(body['message']).to eq('No user found')
        end

        it 'returns a not_found status' do
          expect(response.status).to eq(404)
        end
      end

      context 'when empty' do
        let(:params) { { user: '' } }

        it 'returns error' do
          expect(body['success']).to be_falsey
        end

        it 'returns a message' do
          expect(body['message']).to eq('No user found')
        end

        it 'returns a not_found status' do
          expect(response.status).to eq(404)
        end
      end
    end

    context 'when username is present' do
      context 'when it has undesirable characters' do
        let(:params) { { username: 'd@nn!emag' } }

        it 'returns error' do
          expect(body['success']).to be_falsey
        end

        it 'returns a message' do
          expect(body['message']).to eq('Abnormal user name')
        end

        it 'returns a bad_request status' do
          expect(response.status).to eq(400)
        end
      end

      context 'when characters are ok' do
        let(:params) { { username: 'danniemag' } }

        it 'returns success' do
          expect(body['success']).to be_truthy
        end

        it 'returns a message' do
          expect(body['message']).to eq('Checking stars from user danniemag')
        end

        it 'returns an ok status' do
          expect(response.status).to eq(200)
        end

        it 'enqueues a job' do
          expect(::CheckStarsJob).to have_enqueued_sidekiq_job('danniemag')
        end
      end
    end
  end
end
