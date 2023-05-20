require "rails_helper"
require "faker"

RSpec.describe Contexts::Posts::Repository, type: :model do
  context "create method" do
    it "it success" do
      event_store = Contexts::Posts::Repository.new.create_post(
        user_id: SecureRandom.uuid, 
        insights: "I'm amazing", feeling: 5
        )
      expect(event_store).to have_published(an_event(PostWasCreated))
    end
  end

  context "add like method" do
    let(:user) {
      User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: "123456",
        phone_number: 667089810
      )
    }

    let(:post) {
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: []
      )
    }

    it "it success" do
      args = {
        id: post.id
      }
      event_store = Contexts::Posts::Repository.new.add_like(args: args, current_user_id: user.id)
      expect(event_store).to have_published(an_event(PostWasLiked))
      post.reload
      expect(post.likes).equal?([user.id])
    end
  end

  context "unlike method" do
    let(:user) {
      User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: "123456",
        phone_number: 667089810
      )
    }

    let(:post) {
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: [user.id],
      )
    }

    it "it success" do
      event_store = Contexts::Posts::Repository.new.unlike(
        args: { id: post.id },
        current_user_id: user.id
      )
      expect(event_store).to have_published(an_event(PostWasUnliked))
      post.reload
      expect(post.likes).equal?([])
    end
  end
end
