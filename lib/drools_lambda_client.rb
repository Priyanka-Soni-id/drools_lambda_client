require "drools_lambda_client/version"
require "drools_lambda_client/lambda_client"
require "active_support/core_ext/string"

module DroolsLambdaClient
  extend self

  def execute!(data_hash:, namespace:, lambda_function:)
    response = LambdaClient.invoke(
        lambda_function,
        hash_to_drools(data_hash: data_hash, namespace: namespace).to_json
      ).payload.read
    begin 
      drools_to_hash(response_data: JSON.parse(response, symbolize_names: true))
    rescue => ex
      raise "#{response}---#{ex}"
    end  
  end

  private

  def hash_to_drools(data_hash: , namespace:)
    payload = {}
    payload["namespace"] = [{"name" => namespace}]

    data_hash.each do |object_type, data_objects|
      object_type = object_type.to_s.camelize(:lower)
      objects = []
      data_objects = [data_objects] unless data_objects.is_a? Array
      data_objects.each do |data_object|
        data_object = data_object.inject({}) do |h, (k,v)|
          h[k.to_s.camelize(:lower)] = v;h
        end

        objects << data_object
      end
      payload[object_type] = objects
    end

    payload
  end

  def drools_to_hash(response_data:)
    result_hash = {}
    response_data.each do |object_type, data_objects|
      object_type = object_type.to_s.underscore.to_sym
      objects = []
      data_objects.each do |data_object|
        data_object = data_object.inject({}) do |h, (k,v)|
          h[k.to_s.underscore.to_sym] = v;h
        end
        objects << data_object
      end
      result_hash[object_type] = objects
    end
    result_hash
  end
end
