# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Contexts::Comments::Repository, type: :model do
  subject(:repository) do
    Contexts::Comments::Repository.new
  end
  context 'create method' do
    it 'it success' do
      expect do
        repository.create(
          args: {
            user_id: SecureRandom.uuid,
            post_id: SecureRandom.uuid,
            text: "I'm amazing"
          }
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'add like method' do
    let(:user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_089_810
      )
    end

    let(:post) do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: []
      )
    end

    let(:comment) do
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: []
      )
    end

    it 'it success' do
      args = {
        id: comment.id
      }
      event_store = repository.add_like(args:, current_user_id: user.id)
      expect(event_store).to have_published(an_event(CommentWasLiked))
      comment.reload
      expect(comment.likes).equal?([user.id])
    end
  end

  context 'unlike method' do
    let(:user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_089_810
      )
    end

    let(:post) do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: [user.id]
      )
    end

    let(:comment) do
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: [user.id]
      )
    end

    it 'it success' do
      event_store = repository.unlike(
        args: { id: comment.id },
        current_user_id: user.id
      )
      expect(comment.likes.size).equal?(1)
      expect(event_store).to have_published(an_event(CommentWasUnliked))
      comment.reload
      expect(comment.likes).equal?([])
    end
  end

  context 'update method' do
    let(:user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_089_810
      )
    end

    let(:post) do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        text: 'ah',
        likes: [user.id]
      )
    end

    let(:comment) do
      Comment.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        post_id: post.id,
        text: "I'm amazing",
        likes: []
      )
    end

    it 'it success' do
      args = {
        id: comment.id,
        text: 'hahaha'
      }
      event_store = repository.update(args:)
      expect(event_store).to have_published(an_event(CommentWasUpdated))
    end
  end
end
