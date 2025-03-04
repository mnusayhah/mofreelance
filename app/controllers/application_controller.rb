class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :company, :phone_number])
  end

  def enterprise_user?
    current_user&.role == 'enterprise'
  end

  # Redirection après connexion selon le rôle de l'utilisateur
  def after_sign_in_path_for(resource)
    if resource.enterprise?
      enterprise_dashboard_path
    elsif resource.freelancer?
      freelancer_dashboard_path
    else
      root_path
    end
  end
end
