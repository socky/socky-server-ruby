Rack::WebSocket::Application.class_eval do
  def call(env)
    @env = env
    return self
  end
  
  def send_data(data)
    true
  end
  
  def close_websocket
    on_close(@env)
  end
end
