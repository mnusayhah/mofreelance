module Freelancer
  class DashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!

    def show
      # Récupération des données du freelancer
      @freelancer = current_user
      @shared_projects = SharedProject.where(freelancer_id: current_user.id)
      @projects = @freelancer.projects.joins(:shared_projects).where(shared_projects: { status: ['pending', 'accepted'] })

      # Gestion de la vue à afficher (projets par défaut)
      @view = params[:view] || 'projects'

      # Si la vue est 'profile', on récupère le profil
      if @view == 'profile'
        @profile = current_user.profile
      end

      # On considère tous les formats de réponse
      respond_to do |format|
        format.html  # Vue HTML complète
        format.turbo_stream  # Support pour Turbo Stream
      end
    end

    def freelancer
      @ongoing_projects = current_user.shared_projects.where(status: 'accepted')
      @pending_projects = current_user.shared_projects.where(status: 'pending')
      @completed_projects = current_user.shared_projects.where(status: 'completed')

      respond_to do |format|
        format.html  # Vue HTML complète
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            params[:turbo_frame],
            partial: "projects_list",
            locals: { projects: instance_variable_get("@#{params[:turbo_frame]}") }
          )
        end
      end
    end

    def profile
      @profile = current_user.profile

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def projects
      status = params[:status] || 'accepted'
      @projects = current_user.shared_projects.where(status: status)

      respond_to do |format|
        format.turbo_stream
        format.html { render partial: "projects_list", locals: { projects: @projects } }
      end
    end

    private

    def ensure_freelancer!
      unless current_user.role == "freelancer"
        redirect_to root_path, alert: "Access denied! You must be a freelancer."
      end
    end
  end
end
