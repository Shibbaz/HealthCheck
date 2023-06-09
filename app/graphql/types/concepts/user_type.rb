module Types
  module Concepts
    class Concepts::UserType < Types::Base::Object
      field :id, ID, null: false
      field :name, String, null: false
      field :email, String, null: false
      field :phone_number, Int, null: false
      field :gender, String, null: false

      def email
        object.email
      end

      def gender
        case object.gender
        when 0
          'man'
        else
          'woman'
        end
      end
    end
  end
end