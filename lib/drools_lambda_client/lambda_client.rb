require "aws-sdk"

module LambdaClient
  module_function

  def invoke(function, payload)
    @client ||= get_lambda_client
    response = @client.invoke({ function_name: function, payload: payload})
    return response
  end

  def get_lambda_client
    access_id,secret_key = ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']

    if access_id.nil? || secret_key.nil?
      raise ArgumentError.new("AWS Access ID and secret token not set. Set using ENV['AWS_ACCESS_KEY_ID'] and ENV['AWS_SECRET_ACCESS_KEY']")
    end

    credentials = Aws::Credentials.new(access_id,secret_key)
    region = ENV['AWS_REGION'] || 'us-east-1'

    lambda_client = Aws::Lambda::Client.new(region: region, credentials: credentials)

    return lambda_client
  end

end