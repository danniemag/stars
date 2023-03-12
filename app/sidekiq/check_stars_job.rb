# frozen_string_literal: true

# Job to communicate with Github's API
# and pass information to the persisting service.
class CheckStarsJob
  include Sidekiq::Job
  require 'rest-client'

  def perform(username)
    url = "https://api.github.com/users/#{username}/repos"
    response = RestClient.get(url)

    RegisterUserStarsService.new(username, JSON.parse(response)).call
  rescue RestClient::NotFound
    nil
  end
end
