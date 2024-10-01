# frozen_string_literal: true

RSpec.describe InternalNotifications do
  it "has a version number" do
    expect(InternalNotifications::VERSION).not_to be nil
  end
end
