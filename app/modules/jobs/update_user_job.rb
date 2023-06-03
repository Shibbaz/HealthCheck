# frozen_string_literal: true

class UpdateUserJob < ApplicationJob
  queue_as :update_user
  acidic_by_job_arguments
  include AcidicJob::Mixin

  def perform(_params)
    with_acidic_workflow persisting: { params: nil } do |workflow|
      workflow.step :send_email
    end
  end

  # ...

  def send_email
    UpdateUserMailer.with(
      receiver: arguments.first[:args][:email],
      password_digest: arguments.first[:args][:password]
    ).afterwards.deliver_now!
  end
end
