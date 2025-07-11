class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birth_date, :parental_consent, :parent_email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :birth_date, :parental_consent, :parent_email])
  end

  after_action :send_parental_consent_email, if: :user_signed_up_and_minor?

  private

  def user_signed_up_and_minor?
    params[:controller] == 'devise/registrations' && 
    params[:action] == 'create' && 
    current_user&.minor? && 
    current_user.parent_email.present?
  end

  def send_parental_consent_email
    # In a real app, you'd send an actual email
    # For now, we'll just show the consent URL in a flash message
    consent_url = parental_consent_url(token: current_user.parental_consent_token)
    flash[:notice] = "Registration successful! Please ask your parent/guardian to visit this link to approve your account: #{consent_url}"
  end
end
