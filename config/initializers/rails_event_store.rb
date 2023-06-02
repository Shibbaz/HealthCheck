# frozen_string_literal: true

Rails.configuration.to_prepare do
  config = Rails.configuration
  event_subscriptions = Services::Events::Prepare.call
  Services::Events::Subscribe.call(events: event_subscriptions)
end
