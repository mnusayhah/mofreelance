module Enterprise
  class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_review, only: [:show, :edit, :update, :destroy]
    skip_before_action :set_review, only: [:test]

    # GET /reviews/test
    def test
      render :test
    end

    # GET /reviews/new
    def new
      @review = Review.new
      @review.project_id = params[:project_id] if params[:project_id]
      @review.rated_user_id = params[:rated_user_id] if params[:rated_user_id]
    end

    # POST /reviews
    def create
      @review = current_user.reviews_given.build(review_params)
      if @review.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("review-form-container", partial: "reviews/review_submitted", locals: { review: @review })
          end
          format.html { redirect_to dashboard_path, notice: "Votre avis a été enregistré." }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("review-form-container", partial: "reviews/form", locals: { review: @review })
          end
          format.html { render :new }
        end
      end
    end

    # GET /reviews/:id
    def show
      # Affiche le review
    end

    # GET /reviews/:id/edit
    def edit
      # Affiche le formulaire d'édition
    end

    # PATCH/PUT /reviews/:id
    def update
      if @review.update(review_params)
        redirect_to @review, notice: "Votre avis a été mis à jour."
      else
        render :edit
      end
    end

    # DELETE /reviews/:id
    def destroy
      @review.destroy
      redirect_to dashboard_path, notice: "Votre avis a été supprimé."
    end

    private

    def set_review
      @review = Review.find(params[:id])
    end

    def authorize_review
      redirect_to(root_path, alert: "Accès non autorisé.") unless @review.user == current_user
    end

    def review_params
      params.require(:review).permit(:rated_user_id, :project_id, :score, :comment)
    end
  end
end
