# Purpose: Suggests users to follow based on if any of them have interacted with the current user.
# This is a service class that is used in the graphql subscription type.

module Services
    class Suggestions
        def self.suggest(user:)
            if user.eql?(nil)
                 raise ArgumentError.new("User can't be nil") 
            end
            command = self.query(receiver_id: user.id)
            authors = -> {
                User.where(id: command.pluck(:author_id)).load_async.map {|entity|
                    mutual = ->(followers) { 
                        ids = user.followers & followers
                        self.connectionsNearby(ids)
                    }
                    occurances = command.reject{|object| object.author_id != entity.id}.count
                    payload = self.userPayload(entity)
                    payload.mutual = mutual.call(entity.followers)
                    payload.occurances = occurances
                    payload
                }
            }
            payload(
                user: user, 
                authors: authors.call.sort_by { |hsh| hsh[:occurances] }.reverse
            )
        end

        def self.create(receiver_id:, author_id:)
            Suggestion.create(receiver_id: receiver_id, author_id: author_id)
        end

        private

        def self.query(receiver_id:, time: DateTime.now)
            Suggestion.where(
                receiver_id: receiver_id,
                created_at: (time.beginning_of_day..time.end_of_day)
            ).load_async.order(created_at: :desc).limit(20)
        end

        def self.connectionsNearby(ids)
            User.where(id: ids).load_async.map {|user|
                OpenStruct.new(id: user.id, name: user.name, followersCount: user.followers.count)
            }
        end
        
        def self.userPayload(user)
            OpenStruct.new(id: user.id, name: user.name, followers: user.followers.count)
        end

        def self.payload(user:, authors:)
            OpenStruct.new(user: userPayload(user), authors: authors)
        end
    end
end
