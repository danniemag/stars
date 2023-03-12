# frozen_string_literal: true

# Service to create {StarTrack} records out of data returned from Github's API.
class RegisterUserStarsService
  attr_reader :username, :items

  # Allow calling at the class level.
  # Initializes a new instance of the service class and {#call} calls it.
  #
  # @see #initialize
  # @see #call
  def self.call(*args)
    new(*args).call
  end

  #
  # @param username [String] The username to be researched
  # @option items [Array] Content returned from Github's API
  #
  def initialize(username, items)
    @username = username
    @items = items
  end

  # Iterates on every repository from given user if any
  # and persist data on StartTrack table.
  #
  # @return [Result]
  def call
    return if items.count.zero?

    to_be_persisted = []

    items.each do |r|
      to_be_persisted << { username:,
                           repository_name: r['name'],
                           star_count: r['stargazers_count'] }
    end

    StarTrack.create(to_be_persisted)
  end
end
