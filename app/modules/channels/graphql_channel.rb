class GraphqlChannel < ApplicationCable::Channel
  def execute(data)
    result = 
      HealthSchema.execute(
        query: data["query"],
        context: context,
        variables: Hash(data["variables"]),
        operation_name: data["operationName"],
      )

    transmit(
      result: result.subscription? ? { data: nil } : result.to_h,
      more: result.subscription?,
    )
  end

  def unsubscribed
    HealthSchema.subscriptions.delete_channel_subscriptions(self)
  end

  private

  def context
    {
      ip: ActionDispatch::Request.new(connection.env).remote_ip,
      channel: self
    }
  end
end
