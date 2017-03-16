class IuguApi
  BaseURL = 'https://api.iugu.com/v1/'

  def initialize(api_token)
    @api_token = api_token
  end

  def request(method, path, params)
    url = build_url(path)
    request = request_class(method).new(url.path)
    request.content_type = 'application/x-www-form-urlencoded'
    request.set_form_data(build_params(params))
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    build_response(http.start {|http| http.request(request) })
  end

  def post(path, params)
    request(:post, path, params)
  end

  def get(path, params)
    request(:get, path, params)
  end

  def put(path, params)
    request(:put, path, params)
  end

  def delete(path, params)
    request(:delete, path, params)
  end

  private

  def build_params(params)
    params.merge({"api_token" => @api_token})
  end

  def build_url(path)
    URI.parse("#{BaseURL}#{path}")
  end

  def request_class(method)
    "Net::HTTP::#{method.to_s.capitalize}".constantize
  end

  def build_response(response)
    {code: response.code, body: JSON.parse(response.body), success: (response.code == "200")}
  end
end
