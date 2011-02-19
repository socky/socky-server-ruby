# module Socky
#   class Connection
#     # authentication module - included in Socky::Connection
#     module Authentication
#       include Socky::Misc
#
#       # check if user is valid and then send him authentication data and add to pool
#       # if not then user is given failure response(so user javascript
#       # will know that is should not reconnect again) and then is disconnected
#       # admin user is automaticaly authenticated but isn't added to pool
#       # he will be authenticated when he will try to send message
#       # thanks to that admin don't need to wait for authentication confirmation
#       # on every connection so it will fasten things for him
#       def subscribe_request
#         send_subscribe_request do |response|
#           if response
#             debug [self.name, "authentication successed"]
#             add_to_pool
#             EventMachine.add_timer(0.1) do
#               send_authentication("success")
#             end
#             @authenticated_by_url = true
#           else
#             debug [self.name, "authentication failed"]
#             EventMachine.add_timer(0.1) do
#               send_authentication("failure")
#               disconnect
#             end
#           end
#         end unless admin || authenticated?
#       end
#
#       # if user is authenticated then he is removed from pool and
#       # unsubscribe notification is sent to server unless he is admin
#       # if user is not authenticated then nothing will happen
#       def unsubscribe_request
#         if authenticated?
#           remove_from_pool
#           send_unsubscribe_request{} unless admin
#         end
#       end
#
#       # if user is admin then his secred is compared with server secred
#       # in user isn't admin then it checks if user is authenticated by
#       # server request(defaults to true if subscribe_url is nil)
#       def authenticated?
#         @authenticated ||= (admin ? authenticate_as_admin : authenticate_as_user)
#       end
#
#       private
#
#       def send_authentication(msg)
#         send_data({:type => :authentication, :body => msg})
#       end
#
#       def authenticate_as_admin
#         options[:secret].nil? || secret == options[:secret]
#       end
#
#       def authenticate_as_user
#         authenticated_by_url?
#       end
#
#       def authenticated_by_url?
#         @authenticated_by_url
#       end
#
#       def send_subscribe_request(&block)
#         subscribe_url = options[:subscribe_url]
#         if subscribe_url
#           debug [self.name, "sending subscribe request to", subscribe_url]
#           Socky::NetRequest.post(subscribe_url, params_for_request, &block)
#           true
#         else
#           yield true
#         end
#       end
#
#       def send_unsubscribe_request(&block)
#         unsubscribe_url = options[:unsubscribe_url]
#         if unsubscribe_url
#           debug [self.name, "sending unsubscribe request to", unsubscribe_url]
#           Socky::NetRequest.post(unsubscribe_url, params_for_request, &block)
#         else
#           yield true
#         end
#       end
#
#       def params_for_request
#         {
#           :user_id => user,
#           :user_secret => secret,
#           :channels => channels
#         }.reject{|key,value| value.nil? || value.empty?}
#       end
#
#     end
#   end
# end