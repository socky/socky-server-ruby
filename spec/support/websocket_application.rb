Rack::WebSocket::Application.class_eval do
  def call(env)
    @env = env
    return self
  end
  
  def close_websocket
    on_close
  end
end
