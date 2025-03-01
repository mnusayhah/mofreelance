class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :new, :destroy]
  before_action :set_profile, only: [:show, :edit, :update]

  # Afficher la liste des profils de freelances
  @profiles = Profile.joins(:user).where(users: { role: :freelancer })

  # if params[:q].present?
  #   @profiles = @profiles.where("job_title ILIKE :query OR skills ILIKE :query OR language ILIKE :query", query: "%#{params[:q]}%")
  # end

  # @profiles = @profiles.where("job_title ILIKE ?", "%#{params[:job_title]}%") if params[:job_title].present?
  # @profiles = @profiles.where("skills ILIKE ?", "%#{params[:skills]}%") if params[:skills].present?
  # @profiles = @profiles.where("education ILIKE ?", "%#{params[:education]}%") if params[:education].present?

  #def show
    #if @profile.user.freelancer?
      #render :show
    #else
      #redirect_to freelancer_profiles_path, alert: "Ce profil n'est pas disponible."
    #end
  #end

  def show
    @profile = Profile.find(params[:id])
      if @profile.user.freelancer?
        @projects = Project.where(user_id: current_user.id, status: 'open')
        Rails.logger.debug "Open projects for freelancer #{current_user.id}: #{@projects.inspect}"
        render :show
      else
        redirect_to freelancer_profiles_path, alert: "Ce profil n'est pas disponible."
      end
  end

  # Mettre à jour le profil
  def update
    if @profile.user == current_user
      if @profile.update(profile_params)
        redirect_to @profile, notice: "Votre profil a été mis à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to freelancer_profiles_path, alert: "Vous ne pouvez pas modifier ce profil."
    end
  end

  def new
    @profile = Profile.new
    @profile.skills.build # Ajoute un skill vide pour le formulaire
    @profile.educations.build
  end

  def edit
    if @profile.user == current_user
      render :edit
    else
      redirect_to freelancer_profiles_path, alert: "Vous ne pouvez modifier que votre propre profil."
    end
  end

  def destroy
    if @profile.user == current_user
      @profile.destroy
      redirect_to freelancer_profiles_path, notice: "Votre profil a été supprimé avec succès."
    else
      redirect_to freelancer_profiles_path, alert: "Vous ne pouvez pas supprimer ce profil."
    end
  end

    # Action "me" pour permettre à l'utilisateur connecté d'accéder à son propre profil
  def me
    @profile = current_user.profile
    if @profile
      # Tu peux choisir d'afficher la vue d'édition ou simplement le profil en mode lecture.
      # Ici, nous redirigeons vers l'édition pour faciliter la modification.
      render :edit
    else
      # Optionnel : Si le profil n'existe pas, rediriger l'utilisateur vers une page de création ou un message d'alerte.
      redirect_to freelancer_profiles_path, alert: "Votre profil n'existe pas encore."
    end
  end

  # Crée un profil en BDD à partir des infos du formulaire
  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      redirect_to @profile, notice: "Profil créé avec succès"
    else
      render :new
    end
  end

    # Recherche globale (pg_search, ou un simple LIKE)
    if params[:query].present?
      @profiles = @profiles.search_by_freelance_data(params[:query])
      # ou bien @profiles = @profiles.where("title ILIKE :query OR bio ILIKE :query", query: "%#{params[:query]}%")
    end

    # Disponibilité
    if params[:availability_status].present?
      @profiles = @profiles.where(availability_status: params[:availability_status])
    end

    # Expérience
    if params[:experience_range].present?
      case params[:experience_range]
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
      # Cherche si la skill tapée se trouve dans la chaîne `tech_skills`
      # (ou tu peux faire un split pour matcher plusieurs).
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

  private

  def set_profile
    @profile = Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to freelancer_profiles_path, alert: "Profil introuvable."
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
