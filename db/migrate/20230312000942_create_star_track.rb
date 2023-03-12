# frozen_string_literal: true
class CreateStarTrack < ActiveRecord::Migration[7.0]
  def change
    create_table :star_tracks do |t|
      t.string  :username, null: false
      t.string  :repository_name, null: false
      t.integer :star_count, null: false, default: 0

      t.timestamps
    end
  end
end
