class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  # GET /categories — list all, ordered alphabetically by name
  def index
    categories = Category.order(:name)
    render json: categories.map { |category| category_json(category) }
  end

  # GET /categories/:id — show one, including its equipment count
  def show
    render json: category_json(@category)
  end

  # POST /categories
  def create
    category = Category.create!(category_params)
    render json: category_json(category), status: :created
  end

  # PATCH/PUT /categories/:id
  def update
    @category.update!(category_params)
    render json: category_json(@category)
  end

  # DELETE /categories/:id — 409 if equipment still references it, else delete
  def destroy
    equipment_count = @category.equipment.count
    if equipment_count.positive?
      render json: { error: "Cannot delete category. #{equipment_count} equipment items still belong to it." },
             status: :conflict
    else
      @category.destroy
      head :no_content
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def category_json(category)
    category.as_json(only: %i[id name created_at updated_at])
            .merge(equipment_count: category.equipment.count)
  end
end
