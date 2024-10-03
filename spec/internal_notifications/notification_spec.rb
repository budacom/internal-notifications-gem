require 'spec_helper'

RSpec.describe InternalNotifications::Notification do
  let(:pubsub_client) { instance_double(InternalNotifications::PubsubClient) }
  let(:source) { 'surbtc' }
  let(:env) { 'staging' }
  let(:project_id) { 'project-id' }
  let(:topic_id) { 'messages-topic-id' }
  let(:notification_service) do
    described_class.new(
      topic_id: topic_id,
      project_id: project_id,
      source: source,
      env: env
    )
  end
  let(:platform) { 'slack' }
  let(:title) { 'some title' }
  let(:message) { 'hello world!' }
  let(:type) { 'warning' }
  let(:to) { 'some-destination' }
  let(:datetime) { DateTime.now.strftime('%d/%m/%Y %H:%M') }
  let(:expected_message) do
    {
      source: source,
      env: env,
      platform: platform,
      message: message,
      type: type,
      to: to,
      datetime: datetime,
      title: title
    }
  end

  def perform
    notification_service.send(
      platform: platform,
      title: title,
      message: message,
      type: type,
      to: to
    )
  end

  before do
    allow(InternalNotifications::PubsubClient).to receive(:new).and_return(pubsub_client)
    allow(pubsub_client).to receive(:publish).and_return('message sent')
  end

  shared_examples 'publishes a message to google pubsub' do
    it do
      perform

      expect(pubsub_client)
        .to have_received(:publish)
        .with(expected_message.to_json)
    end
  end

  it_behaves_like 'publishes a message to google pubsub'

  context 'when title is not present' do
    let(:title) { nil }

    before do
      expected_message.delete(:title)
    end

    it_behaves_like 'publishes a message to google pubsub'
  end

  context 'when pubsub client returns nil' do
    before do
      allow(pubsub_client).to receive(:publish).and_return(nil)
    end

    it 'raises error' do
      expect { perform }.to raise_error(InternalNotifications::Error, 'Failed to send message')
    end
  end
end
