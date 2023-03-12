# frozen_string_literal: true

# Job to communicate with Github's API
# and pass information to the persisting service.
class CheckStarsJob
  include Sidekiq::Job
  require 'rest-client'

  def perform(user)
    url = "https://api.github.com/users/#{user}/repos"
    response = RestClient.get(url)

    RegisterUserStarsService.new(user, JSON.parse(response)).call
  rescue RestClient::NotFound
    nil
  end
end
