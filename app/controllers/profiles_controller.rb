class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :new, :destroy]
  before_action :set_profile, only: [:show, :edit, :update]

  # Afficher la liste des profils de freelances
  def index
    @profiles = Profile.joins(:user).where(users: {role: :freelancer})
  end

  # Afficher un profil en détail d'un freelance
  def show
    if @profile.user.freelancer?
      render :show
    else
      redirect_to profiles_path, alert: "Ce profil n'est pas disponible."
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
      redirect_to profiles_path, alert: "Vous ne pouvez pas modifier ce profil."
    end
  end

  def new
    @profile = Profile.new
    @profile.skills.build  # Ajoute un skill vide pour le formulaire
    @profile.educations.build
  end

  def edit
    if @profile.user == current_user
      render :edit
    else
      redirect_to profiles_path, alert: "Vous ne pouvez modifier que votre propre profil."
    end
  end

  def destroy
    if @profile.user == current_user
      @profile.destroy
      redirect_to profiles_path, notice: "Votre profil a été supprimé avec succès."
    else
      redirect_to profiles_path, alert: "Vous ne pouvez pas supprimer ce profil."
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
      redirect_to profiles_path, alert: "Votre profil n'existe pas encore."
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
