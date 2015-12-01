class Admin::ReviewsController < Admin::AdminController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @reviews = Review.all
    respond_with(@reviews)
  end

  def show
    respond_with(@review)
  end

  def new
    @review = Review.new
    respond_with(@review)
  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.save
    respond_with([:admin, @review])
  end

  def update
    @review.update(review_params)
    respond_with([:admin, @review])
  end

  def destroy
    @review.destroy
    respond_with([:admin, @review])
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(:student_id, :avatar, :rating, :bootcamp_id, :body, :original_date, :language)
    end
end
