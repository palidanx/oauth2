module OAuth2
  class AccessToken
    attr_reader :client, :token, :refresh_token, :expires_in, :expires_at

    def initialize(client, token, refresh_token = nil, expires_in = nil)
      @client = client
      @token = token
      @refresh_token = refresh_token
      @expires_in = (expires_in.nil? || expires_in == '') ? nil : expires_in.to_i
     #the following line is a bug.  If you add the current time + time it expires in, it results in a value bigger than time allows
     # @expires_at = Time.now + @expires_in if @expires_in

     #now the patched code says, if there is an expires_in time, set it to expires_at, otherwise use the current time
     @expires_at = @expires_in ?  @expires_in : Time.now


    end
    
    # True if the token in question has an expiration time.
    def expires?
      !!@expires_in
    end
    
    def request(verb, path, params = {}, headers = {})
      @client.request(verb, path, params.merge('access_token' => @token), headers.merge('Authorization' => "Token token=\"#{@token}\""))
    end
    
    def get(path, params = {}, headers = {})
      request(:get, path, params, headers)
    end
    
    def post(path, params = {}, headers = {})
      request(:post, path, params, headers)
    end
    
    def put(path, params = {}, headers = {})
      request(:put, path, params, headers)
    end
    
    def delete(path, params = {}, headers = {})
      request(:delete, path, params, headers)
    end
  end
end
