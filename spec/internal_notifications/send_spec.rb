require 'spec_helper'

RSpec.describe InternalNotifications::Send do
  let(:pubsub_client) { instance_double(InternalNotifications::PubsubClient) }
  let(:platform) { 'slack' }
  let(:message) { 'hello world!' }
  let(:type) { 'warning' }
  let(:to) { 'some-destination' }
  let(:project_id) { 'project-id' }
  let(:topic_id) { 'messages_topic_id' }
  let(:expected_message) do
    {
      platform: platform,
      message: message,
      type: type,
      to: to
    }.to_json
  end

  def perform
    described_class.for(platform: platform, message: message, type: type, to: to,
                        project_id: project_id, topic_id: topic_id)
  end

  before do
    allow(InternalNotifications::PubsubClient).to receive(:new).and_return(pubsub_client)
    allow(pubsub_client).to receive(:publish).and_return('message sent')
  end

  it 'publishes a message to google pubsub' do
    perform

    expect(pubsub_client).to have_received(:publish).with(expected_message)
  end

  context 'when PubsubClient returns nil' do
    before do
      allow(pubsub_client).to receive(:publish).and_return(nil)
    end

    it 'raises error' do
      expect { perform }.to raise_error(InternalNotifications::Error, 'Failed to send message')
    end
  end
end
