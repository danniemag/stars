class StarsController < ApplicationController
  before_action :no_user_found, if: -> { params[:user].blank? }
  before_action :sanitize_entry, if: -> { params[:username].present? }

  def index
    CheckStarsJob.perform_async(params[:user])

    render_response(true, "Checking stars from user #{params[:user]}", :ok)
  end

  private

  def no_user_found
    render_response(false, 'No user found', :not_found)
  end

  def sanitize_entry
    # Prevent against injections and/or undesirable characters
    return if params[:username].index(/[^[:alnum:]&[-]&[_]]/).nil?

    render_response(false, 'Abnormal user name', :bad_request)
  end

  def render_response(success, message, status = :ok)
    render json: { success: success, message: message }, status: status
  end
end
