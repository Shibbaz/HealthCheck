require "rails_helper"
require "faker"

RSpec.describe Contexts::Posts::Repository, type: :model do
  subject(:repository) {
    Contexts::Posts::Repository.new
  }
  context "create method" do
    it "it success" do
      byebug
      expect {
        event_store = repository.create(
          args: {
            user_id: SecureRandom.uuid,
            text: "I'm amazing",
            feeling: 5
          }
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "add like method" do
    let(:user) {
      User.create!(
        id: SecureRandom.uuid,
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
      event_store = repository.add_like(args: args, current_user_id: user.id)
      expect(event_store).to have_published(an_event(PostWasLiked))
      post.reload
      expect(post.likes).equal?([user.id])
    end
  end

  context "unlike method" do
    let(:user) {
      User.create!(
        id: SecureRandom.uuid,
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
        likes: [user.id]
      )
    }

    it "it success" do
      event_store = repository.unlike(
        args: {id: post.id},
        current_user_id: user.id
      )
      expect(event_store).to have_published(an_event(PostWasUnliked))
      post.reload
      expect(post.likes).equal?([])
    end
  end

  context "update method" do
    let(:user) {
      User.create!(
        id: SecureRandom.uuid,
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
        text: "ah",
        likes: [user.id]
      )
    }
    it "it success" do
      args = {
        id: post.id,
        insights: "hahaha"
      }
      event_store = repository.update(args: args)
      expect(event_store).to have_published(an_event(PostWasUpdated))
    end
  end

  context "apply_filtering method, no records" do
    it "checks if no user exists" do
      user = User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: "123456",
        phone_number: 667081810
      )

      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: [user.id],
        feeling: 1
      )

      expect {
        Contexts::Posts::Repository.new.apply_filtering(
          args: {
            user_id: SecureRandom.uuid,
            filters: {
              feeling: nil,
              likes: nil,
              created_at: nil,
              followers: true
            }
          }
        )
      }.to raise_error(Contexts::Users::Errors::UserNotFoundError)
    end
  end

  context "apply_filtering method" do
    let(:user) {
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: "123456",
        phone_number: 667089810
      )
    }

    let(:extra_user) {
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: "123456",
        phone_number: 667081810
      )
    }

    before do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: [user.id],
        feeling: 1
      )
      Post.create(
        id: SecureRandom.uuid,
        user_id: extra_user.id,
        likes: []
      )
    end

    it "it has no filters" do
      data = repository.apply_filtering(
        args: {
          filters: {
            feeling: nil,
            likes: nil,
            created_at: nil,
            followers: nil
          }
        }
      )
      expect(data.size).to eq(2)
    end

    it "it has feeling filters" do
      data = repository.apply_filtering(
        args: {
          filters: {
            feeling: 1,
            likes: nil,
            created_at: nil,
            followers: nil
          }
        }
      )
      expect(data.size).to eq(1)
    end

    it "it has likes filters" do
      data = repository.apply_filtering(
        args: {
          filters: {
            feeling: nil,
            likes: true,
            created_at: nil,
            followers: nil
          }
        }
      )
      size = data.size
      likes_counter = data.pluck(:likes).map { |likes|
        likes.size
      }
      expect(likes_counter.first < likes_counter.last).to eq(true)
      expect(size).to eq(2)
    end

    it "it has created_at filters" do
      data = repository.apply_filtering(
        args: {
          filters: {
            feeling: nil,
            likes: nil,
            created_at: true,
            followers: nil
          }
        }
      )
      size = data.size
      dates = data.pluck(:created_at)
      expect(Date.parse(dates.first.to_s) <= Date.parse(dates.last.to_s)).to eq(true)
      expect(size).to eq(2)
    end

    it "it has followers filters" do
      followers = [extra_user.id] + user.followers
      user.update(followers: followers)
      user.reload
      data = repository.apply_filtering(
        args: {
          user_id: user.id,
          filters: {
            feeling: nil,
            likes: nil,
            created_at: nil,
            followers: true
          }
        }
      )
      size = data.size
      expect(size).to eq(2)
    end
  end
end
