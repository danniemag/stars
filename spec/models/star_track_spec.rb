# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe StarTrack, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }

    it { should validate_presence_of(:repository_name) }

    it { should validate_presence_of(:star_count) }
  end
end
