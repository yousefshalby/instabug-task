class ApplicationsController < ApplicationController
  skip_before_action :verify_authenticity_token

    def create
      application = Application.new(application_params)
      if application.save
        render json: application, status: :created, serializer: ApplicationSerializer
      else
        render json: application.errors, status: :unprocessable_entity
      end
    end

    def update
      application = Application.find_by(token: params[:id])
      if not application
        render json: { error: "Application not found" }, status: :not_found
      end
      if application.update(application_params)
        render json: application, serializer: ApplicationSerializer
      else
        render json: application.errors, status: :unprocessable_entity
      end
    end

    def show
      application = Application.find_by(token: params[:id])
      if application
        render json: application, serializer: ApplicationSerializer
      else
        render json: { error: "Application not found" }, status: :not_found
      end
    end

    def index
      applications = Application.all
      render json: applications, each_serializer: ApplicationSerializer
    end

    private

    def application_params
      params.require(:application).permit(:name)
    end
end
