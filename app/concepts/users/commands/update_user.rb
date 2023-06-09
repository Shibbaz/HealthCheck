# Updating Current User

module Concepts
    module Users
      module Commands
        class UpdateUser
          def call(event)
            stream = event.data
            error_type = Services::Records.build_error(adapter: stream[:adapter])
            current_user = stream[:current_user]
            current_user.nil? ? (raise error_type) : nil
            !current_user.email.eql?(stream[:args][:email]) ? (raise Concepts::Users::Errors::UserEmailWasIncorrectError.new) : nil
            
            current_user.with_lock do
              current_user.update!(stream[:args])
            end
            UpdateUserJob.with.perform(stream)
          end
        end
      end
    end
  end
  