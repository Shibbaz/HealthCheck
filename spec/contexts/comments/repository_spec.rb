require "rails_helper"
require "faker"

RSpec.describe Contexts::Comments::Repository, type: :model do
  context "create method" do
    it "it success" do
      expect {
        event_store = Contexts::Comments::Repository.new.create_comment(
          args: {
            user_id: SecureRandom.uuid,
            post_id: SecureRandom.uuid,
            text: "I'm amazing"
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

    let(:comment) {
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: []
      )
    }

    it "it success" do
      args = {
        id: comment.id
      }
      event_store = Contexts::Comments::Repository.new.add_like(args: args, current_user_id: user.id)
      expect(event_store).to have_published(an_event(CommentWasLiked))
      comment.reload
      expect(comment.likes).equal?([user.id])
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

    let(:comment) {
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: [user.id]
      )
    }

    it "it success" do
      event_store = Contexts::Comments::Repository.new.unlike(
        args: {id: comment.id},
        current_user_id: user.id
      )
      expect(comment.likes.size).equal?(1)
      expect(event_store).to have_published(an_event(CommentWasUnliked))
      comment.reload
      expect(comment.likes).equal?([])
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
        insights: "ah",
        likes: [user.id]
      )
    }

    let(:comment) {
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: []
      )
    }

    it "it success" do
      args = {
        id: comment.id,
        text: "hahaha"
      }
      event_store = Contexts::Comments::Repository.new.update(args: args)
      expect(event_store).to have_published(an_event(CommentWasUpdated))
    end
  end
end
