# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Concepts::Posts::Repository, type: :model do
  subject(:repository) do
    Concepts::Posts::Repository.new
  end
  context 'create method' do
    it 'expects successfully creating post' do
      expect do
        repository.create(
          args: {
            user_id: SecureRandom.uuid,
            text: "I'm amazing",
            feeling: 5
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

    it 'expects post to got like' do
      args = {
        id: post.id
      }
      event_store = repository.add_like(args:, current_user_id: user.id)
      expect(event_store).to have_published(an_event(PostWasLiked))
      post.reload
      expect(post.likes).equal?([user.id])
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

    it 'expects successfully unliking post' do
      event_store = repository.unlike(
        args: { id: post.id },
        current_user_id: user.id
      )
      expect(event_store).to have_published(an_event(PostWasUnliked))
      post.reload
      expect(post.likes).equal?([])
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
    it 'expects post to got updated' do
      args = {
        id: post.id,
        insights: 'hahaha'
      }
      event_store = repository.update(args:)
      expect(event_store).to have_published(an_event(PostWasUpdated))
    end
  end

  context 'apply_filtering method, no records' do
    it 'expects to fail, searched user does not exist exists' do
      user = User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_081_810
      )

      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: [user.id],
        feeling: 1
      )

      expect do
        Concepts::Posts::Repository.new.apply_filtering(
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
      end.to raise_error(Concepts::Users::Errors::UserNotFoundError)
    end
  end

  context 'apply_filtering method' do
    let(:user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_089_810
      )
    end

    let(:extra_user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_081_810
      )
    end

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
      Post.create(
        id: SecureRandom.uuid,
        user_id: extra_user.id,
        likes: [],
        visibility: true
      )
    end

    it 'expects to return Posts relation with no filters' do
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
      expect(data.size).to eq(3)
    end

    it 'expects to return relation with feeling filter' do
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

    it 'expects return relation likes filter ' do
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
      likes_counter = data.pluck(:likes).map(&:size)
      expect(likes_counter.first < likes_counter.last).to eq(true)
      expect(size).to eq(3)
    end

    it 'expects return relation through created_at filter' do
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
      expect(size).to eq(3)
    end

    it 'expects return relation through follower filter' do
      followers = [extra_user.id] + user.followers
      user.update(followers:)
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
      expect(size).to eq(3)
    end

    it 'shows no vissible content' do
      data = repository.apply_filtering(
        args: {
          filters: {

          },
          usr: extra_user.id,
          visibility: true
        }
      )
      expect(data.size).to eq(1)
    end

    it 'shows vissible content' do
      data = repository.apply_filtering(
        args: {
          filters: {

          },
          usr: extra_user.id,
          visibility: false
        }
      )
      expect(data.size).to eq(3)
    end
  end
end
