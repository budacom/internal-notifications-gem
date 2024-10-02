require 'spec_helper'

RSpec.describe InternalNotifications::PubsubClient do
  let(:topic_id) { 'some-id' }
  let(:project_id) { 'some-project-id' }
  let(:service) do
    described_class.new(topic_id: topic_id, project_id: project_id)
  end

  describe '#publish' do
    let(:message) { 'hello world' }
    let(:pubsub) { instance_double(Google::Cloud::Pubsub::Project) }
    let(:topic) { instance_double(Google::Cloud::Pubsub::Topic) }

    before do
      allow(Google::Cloud::Pubsub)
        .to receive(:new)
        .with(project_id: project_id)
        .and_return(pubsub)
      allow(pubsub)
        .to receive(:topic)
        .with(topic_id, skip_lookup: true)
        .and_return(topic)
      allow(topic).to receive(:publish)
    end

    def perform
      service.publish(message)
    end

    it 'calls topic on pubsub instance' do
      perform

      expect(pubsub)
        .to have_received(:topic)
        .with(topic_id, skip_lookup: true)
    end

    it 'calls publish on pubsub instance' do
      perform

      expect(topic).to have_received(:publish).with(message)
    end
  end
end
