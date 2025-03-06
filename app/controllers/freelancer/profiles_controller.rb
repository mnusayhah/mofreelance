module Freelancer
  class ProfilesController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :new, :destroy]
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    # 1) Action index : lister et filtrer
    def index
      @profiles = Profile.joins(:user).where(users: { role: :freelancer })

      # Recherche globale (ex: pg_search, ou un simple LIKE)
      if params[:query].present?
        # Exemple : si tu as défini un scope .search_by_freelance_data
        @profiles = @profiles.search_by_freelance_data(params[:query])
        # ou un LIKE :
        # @profiles = @profiles.where("title ILIKE :q OR bio ILIKE :q", q: "%#{params[:query]}%")
      end

      # Disponibilité
      if params[:availability_status].present?
        @profiles = @profiles.where(availability_status: params[:availability_status])
      end

      # Expérience
      if params[:years_of_experience].present?
        case params[:years_of_experience]
        when "0-2"
          @profiles = @profiles.where("years_of_experience <= 2")
        when "3-7"
          @profiles = @profiles.where("years_of_experience BETWEEN 3 AND 7")
        when "8-15"
          @profiles = @profiles.where("years_of_experience BETWEEN 8 AND 15")
        when "16+"
          @profiles = @profiles.where("years_of_experience >= 16")
        end
      end

      # Langue
      if params[:language].present?
        @profiles = @profiles.where(language: params[:language])
      end

      # Localisation
      if params[:address].present?
        @profiles = @profiles.where("address ILIKE ?", "%#{params[:address]}%")
      end

      # Tech Skills
      if params[:tech_skills].present?
        @profiles = @profiles.where("tech_skills ILIKE ?", "%#{params[:tech_skills]}%")
      end

      # Taux horaire min
      if params[:min_rate].present?
        @profiles = @profiles.where("hourly_rate >= ?", params[:min_rate])
      end

      # Taux horaire max
      if params[:max_rate].present?
        @profiles = @profiles.where("hourly_rate <= ?", params[:max_rate])
      end
    end

    # 2) Afficher un profil en détail
    def show
      if @profile.user.freelancer?
        @projects = current_user.projects.where(status: :open)
        render :show
      else
        redirect_to profiles_path, alert: "Ce profil n'est pas disponible."
      end
    end

    # 3) Créer un nouveau profil (form)
    def new
      @profile = Profile.new
      @profile.skills.build      # Ajoute un skill vide pour le formulaire
      @profile.educations.build  # Idem pour education
    end

    # 4) Enregistrer le nouveau profil
    def create
      @profile = current_user.build_profile(profile_params)
      # @profile.user = current_user
      if @profile.save!
        redirect_to [:freelancer, @profile], notice: "Profil créé avec succès"
      else
        render :new
      end
    end

    # 5) Editer un profil
    def edit
      if @profile.user == current_user
        render :edit
      else
        redirect_to profiles_path, alert: "Vous ne pouvez modifier que votre propre profil."
      end
    end

    # 6) Mettre à jour le profil
    def update
      if @profile.user == current_user
        if @profile.update(profile_params)
          redirect_to @profile, notice: "Votre profil a été mis à jour avec succès."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        redirect_to profiles_path, alert: "Vous ne pouvez pas modifier ce profil."
      end
    end

    # 7) Détruire un profil
    def destroy
      if @profile.user == current_user
        @profile.destroy
        redirect_to profiles_path, notice: "Votre profil a été supprimé avec succès."
      else
        redirect_to profiles_path, alert: "Vous ne pouvez pas supprimer ce profil."
      end
    end

    # 8) Action "me" pour accéder à son propre profil
    def me
      @profile = current_user.profile
      if @profile
        # On redirige vers l'édition ou on affiche directement le profil
        render :edit
      else
        redirect_to profiles_path, alert: "Votre profil n'existe pas encore."
      end
    end

    private

    def set_profile
      @profile = Profile.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to profiles_path, alert: "Profil introuvable."
    end

    def profile_params
      params.require(:profile).permit(
        :title, :bio, :address, :years_of_experience, :hourly_rate,
        :availability_status, :language, :avatar, :tech_skills,
        skills_attributes: [:id, :job_title, :company, :start_date, :end_date, :description, :localisation, :_destroy],
        educations_attributes: [:id, :school, :diploma, :start_date, :end_date, :localisation, :_destroy]
      )
    end
  end
end
