require 'power-types'

module InternalNotifications
  class Notification < PowerTypes::Service.new(:topic_id, :project_id)
    def send(platform:, message:, type:, to:)
      message = {
        platform: platform,
        message: message,
        type: type,
        to: to
      }.to_json

      raise InternalNotifications::Error, 'Failed to send message' unless client.publish(message)
    end

    private

    def client
      @client ||= PubsubClient.new(
        topic_id: @topic_id,
        project_id: @project_id
      )
    end
  end
end
