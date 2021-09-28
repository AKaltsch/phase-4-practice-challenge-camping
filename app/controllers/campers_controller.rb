class CampersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entitiy

    def index 
        render json: Camper.all 
    end

    def show  
        camper = Camper.find(params[:id])
        render json: camper, serializer: CamperWithActivitiesSerializer, include: :activities
    end

    def create 
        camper = Camper.create!(camper_params)
        render json: camper, status: :created
    end

    private

    def camper_params
        params.permit(:name, :age)
    end

    def not_found_response  
        render json: {error: "Camper not found"}, status: :not_found
    end

    def render_unprocessable_entitiy(exception)
        render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end
end
