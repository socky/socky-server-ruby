module Socky
  class HTTP
    
    def call(env)
      [
        200,
        {
          'Content-Type' => 'text/html',
          'Content-Length' => '25',
        },
        ['Socky Server HTTP Backend']
      ]
    end
    
  end
end