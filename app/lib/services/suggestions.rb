module Services
    class Suggestions
        def self.suggest(user:)
            time = DateTime.now
            user_id = user.id
            command = Suggestion.where(
                receiver_id: user_id,
                created_at: (time.beginning_of_day..time.end_of_day)
            ).load_async.order(created_at: :desc).limit(10)
            connections = ->(followers) { 
                ids = user.followers & followers
                User.where(id: ids).load_async.map {|user|{
                    id: user.id,
                    name: user.name,
                    followersCount: user.followers.count
                }}
            }
            authors = User.where(id: command.pluck(:author_id)).load_async.uniq
            authors = authors.map {|author| 
                {
                    id: author.id,
                    name: author.name,
                    followersCount: author.followers.count, 
                    followers: connections.call(author.followers)
                }
            }
            { 
                user: {
                    id: user.id,
                    name: user.name,
                    followers: user.followers.count,
                }, 
                authors: authors
            }
        end

        def create_suggestion(receiver_id:, author_id:)
            Suggestion.create(receiver_id: receiver_id, author_id: author_id)
        end
    end
end