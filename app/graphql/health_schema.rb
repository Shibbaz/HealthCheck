class HealthSchema < GraphQL::Schema
  use GraphQL::FragmentCache
  use GraphqlTimeout, max_seconds: 100
  mutation(Types::Registry::MutationType)
  query(Types::Registry::QueryType)
  subscription(Types::Registry::SubscriptionType)
  max_complexity 100
  tracer(GraphQlTracer.new) if ENV['RAILS_ENV'] == 'production' || ENV['RAILS_ENV'] == 'development'
  use GraphQL::Batch
  use GraphQL::AnyCable, broadcast: true, default_broadcastable: true
  use GraphQL::PersistedQueries, compiled_queries: true, store: :redis, redis_client: { redis_url: ENV["REDIS_URL"] }

  def self.resolve_type(_abstract_type, _obj, _ctx)
    raise(GraphQL::RequiredImplementationMissingError)
  end

  validate_max_errors(100)

  def self.id_from_object(object, _type_definition, _query_ctx)
    object.to_gid_param
  end

  def self.object_from_id(global_id, _query_ctx)
    GlobalID.find(global_id)
  end
end
