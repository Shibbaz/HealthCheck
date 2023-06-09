module Types
    class ErrorType < Types::Base::Object
      field :message, String, null: false
    end
end