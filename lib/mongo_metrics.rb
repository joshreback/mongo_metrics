require "mongoid"
require "active_support/notifications"
require "jquery-rails"
require "mongo_metrics/engine"

module MongoMetrics
  EVENT = 'process_action.action_controller'
  ActiveSupport::Notifications.subscribe EVENT do |*args|
    MongoMetrics::Metric.store!(args)
  end
end
