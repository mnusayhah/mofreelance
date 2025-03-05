module Freelancer
  class ProfilesController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :new, :destroy, :me]
    before_action :set_profile, only: [:show, :edit, :update, :destroy]

    # Action me pour voir son propre profil
    def me
      @profile = current_user.profile

      # Pour debug
      Rails.logger.debug "Current user: #{current_user.inspect}"
      Rails.logger.debug "Profile: #{@profile.inspect}"

      if @profile
        # Si le profil existe, on rend la vue
        respond_to do |format|
          format.html # Rend me.html.erb
          format.turbo_stream
        end
      else
        # Si le profil n'existe pas, on redirige vers le formulaire de création
        flash[:alert] = "Votre profil n'existe pas encore. Veuillez en créer un."
        redirect_to new_freelancer_profile_path
      end
    rescue => e
      # Capture toute exception pour le debug
      Rails.logger.error "Erreur dans me: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:error] = "Une erreur s'est produite: #{e.message}"
      redirect_to freelancer_dashboard_path
    end

    # 1) Action index : lister et filtrer
    def index
      @profiles = Profile.joins(:user).where(users: { role: :freelancer })

      # Recherche globale (améliorée)
      if params[:query].present?
        search_term = "%#{params[:query].strip.downcase}%"

        # Version améliorée qui est insensible à la casse et cherche dans plusieurs colonnes
        @profiles = @profiles.where(
          "LOWER(title) LIKE :q OR
           LOWER(bio) LIKE :q OR
           LOWER(tech_skills) LIKE :q OR
           LOWER(address) LIKE :q OR
           LOWER(users.first_name) LIKE :q OR
           LOWER(users.last_name) LIKE :q",
          q: search_term
        ).references(:users)

        # Débogage - regardez ces messages dans votre terminal
        Rails.logger.debug "Terme recherché: #{params[:query]}"
        Rails.logger.debug "Nombre de profils trouvés: #{@profiles.count}"
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
        respond_to do |format|
          format.html
          format.turbo_stream
        end
      else
        redirect_to freelancer_profiles_path, alert: "Ce profil n'est pas disponible."
      end
    end

    # 3) Créer un nouveau profil (form)
    def new
      @profile = Profile.new
      @profile.skills.build      # Ajoute un skill vide pour le formulaire
      @profile.educations.build  # Idem pour education

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    # 4) Enregistrer le nouveau profil
    def create
      @profile = current_user.build_profile(profile_params)

      respond_to do |format|
        if @profile.save
          format.html {
            redirect_to freelancer_dashboard_path(view: 'profile'),
            notice: "Profil créé avec succès"
          }
          format.turbo_stream {
            flash[:notice] = "Profil créé avec succès"
            redirect_to freelancer_dashboard_path(view: 'profile')
          }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
      end
    end

    # 5) Editer un profil
    def edit
      if @profile.user == current_user
        respond_to do |format|
          format.html
          format.turbo_stream
        end
      else
        redirect_to freelancer_profiles_path, alert: "Vous ne pouvez modifier que votre propre profil."
      end
    end

    # 6) Mettre à jour le profil
    def update
      if @profile.user == current_user
        respond_to do |format|
          if @profile.update(profile_params)
            format.html {
              redirect_to freelancer_dashboard_path(view: 'profile'),
              notice: "Votre profil a été mis à jour avec succès."
            }
            format.turbo_stream {
              flash[:notice] = "Votre profil a été mis à jour avec succès."
              redirect_to freelancer_dashboard_path(view: 'profile')
            }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.turbo_stream { render :edit, status: :unprocessable_entity }
          end
        end
      else
        redirect_to freelancer_profiles_path, alert: "Vous ne pouvez pas modifier ce profil."
      end
    end

    # 7) Détruire un profil
    def destroy
      if @profile.user == current_user
        @profile.destroy
        redirect_to freelancer_profiles_path, notice: "Votre profil a été supprimé avec succès."
      else
        redirect_to freelancer_profiles_path, alert: "Vous ne pouvez pas supprimer ce profil."
      end
    end

    private

    def set_profile
      @profile = Profile.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to freelancer_profiles_path, alert: "Profil introuvable."
    end

    def profile_params
      params.require(:profile).permit(
        :title, :bio, :address, :years_of_experience, :hourly_rate,
        :availability_status, :language, :photo, :tech_skills,
        skills_attributes: [:id, :job_title, :company, :start_date, :end_date, :description, :localisation, :_destroy],
        educations_attributes: [:id, :school, :diploma, :start_date, :end_date, :localisation, :_destroy]
      )
    end
  end
end
