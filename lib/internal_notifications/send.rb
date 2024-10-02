require 'power-types'

module InternalNotifications
  class Send < PowerTypes::Command.new(:platform, :message, :type, :to, :project_id, :topic_id)
    def perform
      message = {
        platform: @platform,
        message: @message,
        type: @type,
        to: @to
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
