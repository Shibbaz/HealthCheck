# frozen_string_literal: true

class MailerJob < ApplicationJob
  queue_as :mailer
  acidic_by_job_arguments
  include AcidicJob::Mixin

  def perform(_params)
    with_acidic_workflow persisting: { params: nil } do |workflow|
      workflow.step :send_email
    end
  end

  # ...

  def send_email
    SignUpMailer.with(
      receiver: arguments.first[:email],
      phone_number: arguments.first[:phone_number],
      name: arguments.first[:name]
    ).afterwards.deliver_now!
  end
end
