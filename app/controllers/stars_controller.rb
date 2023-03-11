class StarsController < ApplicationController
  before_action :validate_parameter

  def index
  end

  private

  def validate_parameter
    render_response(false, 'No user found', :not_found)
  end

  def render_response(success, message, status = :ok)
    render json: { success: success, message: message }, status: status
  end
end
