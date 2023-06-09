class GraphqlController < ApplicationController

  def execute
    context = {}

    # Apollo sends the params in a _json variable when batching is enabled
    # see the Apollo Documentation about query batching: http://dev.apollodata.com/core/network.html#query-batching
    result = if params[:_json]
      queries = params[:_json].map do |param|
        {
          query: param[:query],
          operation_name: param[:operationName],
          variables: ensure_hash(param[:variables]),
          context: {
            extensions: ensure_hash(params[:extensions]),
            session:,
            current_user:,
            ip: request.ip
          }
        }
      end
      HealthSchema.multiplex(queries)
    else
      variables = prepare_variables(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      context = {
        extensions: ensure_hash(params[:extensions]),
        session:,
        current_user:,
        ip: request.ip
      }
      result = HealthSchema.execute(query, variables:, context:, operation_name:)
    end
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def current_user
    # if we want to change the sign-in strategy, this is the place to do it
    return unless request.headers['Authorization']

    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
    tk = request.headers['Authorization']
    token = crypt.decrypt_and_verify tk
    user_id = token.gsub('user-id:', '')
    user ||= User.find user_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    # ...code
  end

  def handle_error_in_development(e)
    # ...code
  end
end
