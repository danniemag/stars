# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe CheckStarsJob do
  describe 'run worker' do
    let(:go!) { described_class.perform_async(username) }
    let(:username) { 'danniemag' }

    it 'calls service' do
      service_class = RegisterUserStarsService

      spy_class = spy(service_class.name)
      allow_any_instance_of(RSpec::Mocks::Double).to receive(:class) { service_class }
      sclass = service_class.new(username, [])
      allow(sclass).to receive(:call) { spy_class }

      sclass.call
      expect(sclass).to have_received(:call)
    end
  end
end
