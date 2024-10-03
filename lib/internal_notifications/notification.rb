require 'power-types'
require 'date'

module InternalNotifications
  class Notification < PowerTypes::Service.new(:topic_id, :project_id, :source, :env)
    def send(platform:, message:, type:, to:, title: nil)
      message = {
        source: @source,
        env: @env,
        platform: platform,
        message: message,
        type: type,
        to: to,
        datetime: datetime
      }
      message[:title] = title if title.present?

      publish(message.to_json)
    end

    private

    def client
      @client ||= PubsubClient.new(
        topic_id: @topic_id,
        project_id: @project_id
      )
    end

    def datetime
      DateTime.now.strftime('%d/%m/%Y %H:%M')
    end

    def publish(message)
      raise InternalNotifications::Error, 'Failed to send message' unless client.publish(message)
    end
  end
end
