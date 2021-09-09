class RecipesController < ApplicationController

    def index
        if session[:user_id]
            recipes = Recipe.all
            render json: recipes, include: :user
        else
            render json: {errors: ["Please login"]}, status: 401
        end
    end

    def create
        if session[:user_id]
            user = User.find_by(id: session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created, include: :user
        else
            render json: {errors: ["Please login"]}, status: 401
        end
    rescue ActiveRecord::RecordInvalid => invalid
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user)
    end
end
