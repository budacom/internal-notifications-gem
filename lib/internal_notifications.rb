# frozen_string_literal: true

require_relative 'internal_notifications/version'
require 'internal_notifications/notification'
require 'internal_notifications/pubsub_client'

module InternalNotifications
  class Error < StandardError; end
end
