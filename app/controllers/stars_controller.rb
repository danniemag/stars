class StarsController < ApplicationController
  require 'rest-client'

  before_action :no_user_found, if: -> { params[:user].blank? }

  def index
    url = "https://api.github.com/users/#{params[:user]}/repos"
    response = RestClient.get(url)

  rescue RestClient::NotFound
    no_user_found
  end

  private

  def no_user_found
    render_response(false, 'No user found', :not_found)
  end

  def render_response(success, message, status = :ok)
    render json: { success: success, message: message }, status: status
  end
end
