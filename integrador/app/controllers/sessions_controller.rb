class SessionsController < ApplicationController
  def new
  end

  def create
    token = Api::Authentication.valid_password?(params[:username], params[:password])
    if token.blank?
      redirect_to new_session_path, :alert => "Invalid credentials."
    else
      redirect_to dashboard_path
    end
  end

  def destroy
    @session = Session.find(params[:id])
    @session.destroy
    redirect_to sessions_url, :notice => "Successfully destroyed session."
  end
end
