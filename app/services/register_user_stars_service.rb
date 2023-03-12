# frozen_string_literal: true

# Service to create {StarTrack} records of data returned from Github's API.
class RegisterUserStarsService
  # Allow calling at the class level.
  # Initializes a new instance of the service class and {#call} calls it.
  #
  # @see #initialize
  # @see #call
  def self.call(*args)
    new(*args).call
  end

  #
  # @param user [String] The name of the user to be researched
  # @option response [Array] Content returned from Github's API
  #
  def initialize(user, response)
    @user = user
    @response = response
  end

  # Iterates on every repository from given user if any
  # and persist data on StartTrack table.
  #
  # @return [Result]
  def call
    return if response.count.zero?

    to_be_persisted = []

    response.each do |r|
      to_be_persisted << { name: r['name'], stars_count: r['stargazers_count'] }
    end
  end
end
