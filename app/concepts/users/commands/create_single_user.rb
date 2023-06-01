# frozen_string_literal: true

module Concepts
  module Users
    module Commands
      class CreateSingleUser
        def call(event)
          stream = event.data

          stream[:adapter].create!(
            name: stream[:name],
            email: stream[:email],
            password: stream[:password],
            phone_number: stream[:phone_number],
            gender: stream[:gender]
          )
          MailerJob.with.perform(stream)
        end
      end
    end
  end
end
