class UsersController < ApplicationController
  def show
    # Fetching shared projects for the freelancer user
    if current_user.freelancer? # Assuming you have a method to check if user is a freelancer
      @shared_projects = current_user.shared_projects.where(status: params[:status])
    end
  end
end
