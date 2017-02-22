class ParamsStripper
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    params = remove_invalid_encoding(request.params)
    #anything else you would like to do
    env['QUERY_STRING'] = Rack::Utils.build_nested_query(params)
    @app.call(env)
  end

  private

  def remove_invalid_encoding(params)
    params.each do |key, value|
      if params[key].is_a?(Hash)
        params[key] = remove_invalid_encoding(value)
      else
        remove_encoding(params[key])
      end
    end
  end

  def remove_encoding(param)
    if param.class == String
      param.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end

end
