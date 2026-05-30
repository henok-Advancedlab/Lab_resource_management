class CategoriesController < ApplicationController
  # GET /categories
  def index
    @categories = Category.all
    render json: @categories
  end

  # GET /categories/:id
  def show
    @category = Category.find(params[:id])
    render json: @category
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Category not found" }, status: :not_found
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/:id
  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Category not found" }, status: :not_found
  end

  # DELETE /categories/:id
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Category not found" }, status: :not_found
  end

  private

  def category_params
    params.permit(:name, :description)
  end
end