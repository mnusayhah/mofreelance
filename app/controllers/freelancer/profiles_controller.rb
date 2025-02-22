module Freelancer
  class ProfilesController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :destroy]
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

    private

    def set_profile
      @profile = Profile.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to profiles_path, alert: "Profil introuvable."
    end

    def profile_params
      params.require(:profile).permit(:title, :bio, :hourly_rate, :availability_status, :address, :portfolio_url, :language, :avatar)
    end
  end
end
