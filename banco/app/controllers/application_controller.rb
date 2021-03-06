# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :validate_token
  
  protected
  
  def validate_token
    unless Authentication.valid_token?(params[:token])
      render :xml => { :mensaje => "Token inválido" }.to_xml(:root => "error")
    end
  end
  
  def current_teacher
    @current_teacher ||= Authentication.teacher_for_token(params[:token])
  end
end
