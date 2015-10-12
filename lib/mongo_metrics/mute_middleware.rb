# 3 choices for where to insert this stack:
#
# 1. Between the webserver and the Rails application? Inaccessible, so no.
# 2. Before the router is not appropriate because it would mute all requests.
# 3. A stack inside each controller is best -- we can add it directly to MongoMetrics::ApplicationController
# In reality, this will get added to the engine's middleware stack, so any rquest that goes to the engine will be muted

module MongoMetrics
  class MuteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      MongoMetrics.mute! { @app.call(env) }
    end
  end
end