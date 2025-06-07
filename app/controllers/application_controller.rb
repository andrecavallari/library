class ApplicationController < ActionController::API
  include WardenConcern

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end
end
