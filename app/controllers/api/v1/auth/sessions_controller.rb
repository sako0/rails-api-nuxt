class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  def render_create_success
    render json: {
      success: true
    }, status: 200
    # render json:
    #   data: resource_data(resource_json: @resource.token_validation_response)
    # # {,
    # #   random: SecureRandom.urlsafe_base64
    # # }
  end
end