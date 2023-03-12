# frozen_string_literal: true

# Class name: StarTrack
class StarTrack < ApplicationRecord
  validates_presence_of :username, :repository_name, :star_count
end
