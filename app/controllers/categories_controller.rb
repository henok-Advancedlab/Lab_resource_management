class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  # GET /categories — list all, ordered alphabetically by name.
  # Counts equipment in a single grouped query to avoid an N+1.
  def index
    categories = Category.left_joins(:equipment)
                         .select("categories.*, COUNT(equipment.id) AS equipment_count")
                         .group("categories.id")
                         .order(:name)
    render json: categories.map { |category| category_json(category, category.equipment_count) }
  end

  # GET /categories/:id — show one, including its equipment count
  def show
    render json: category_json(@category, @category.equipment.count)
  end

  # POST /categories
  def create
    category = Category.create!(category_params)
    render json: category_json(category, category.equipment.count), status: :created
  end

  # PATCH/PUT /categories/:id
  def update
    @category.update!(category_params)
    render json: category_json(@category, @category.equipment.count)
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

  def category_json(category, equipment_count)
    category.as_json(only: %i[id name created_at updated_at])
            .merge(equipment_count: equipment_count.to_i)
  end
end
