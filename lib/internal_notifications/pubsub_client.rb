require 'power-types'
require 'google/cloud/pubsub'

module InternalNotifications
  class PubsubClient < PowerTypes::Service.new(:topic_id, :project_id)
    def publish(message)
      topic = pubsub.topic(@topic_id, skip_lookup: true)

      topic.publish(message)
    end

    private

    def pubsub
      @pubsub ||= Google::Cloud::Pubsub.new(project_id: @project_id)
    end
  end
end
