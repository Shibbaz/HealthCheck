module Subscriptions
  class BaseSubscription < GraphQL::Schema::Subscription
    # Hook up base classes
    object_class Types::Base::Object
    field_class Types::Base::Field
    argument_class Types::Base::Argument
  end
end
