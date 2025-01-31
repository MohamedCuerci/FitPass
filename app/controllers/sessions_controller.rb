class SessionsController < ApplicationController
  def store_location
    session[:latitude] = params[:latitude]
    session[:longitude] = params[:longitude]
    render json: { success: true }
  end
end
