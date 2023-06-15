# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Services::Suggestions, type: :model do
    subject(:suggestion){
        Services::Suggestions.suggest(user: User.second)
    }

  context 'create method' do
    before do
        user = create(:user, followers: [])
        extra_user = create(:user, followers: [user.id])
        user.update(followers: [extra_user.id])
        extra_user_user = create(:user, followers: [extra_user.id, user.id])
        create(:user, followers: [])
    end

    before do
        Suggestion.create(receiver_id: User.second.id, author_id: User.first.id)
        Suggestion.create(receiver_id: User.second.id, author_id: User.first.id)
        Suggestion.create(receiver_id: User.second.id, author_id: User.third.id)
        Suggestion.create(receiver_id: User.second.id, author_id: User.third.id)
        Suggestion.create(receiver_id: User.second.id, author_id: User.first.id)
    end

    it 'expects to find suggestions for users' do
      expect(suggestion[:user][:id]).to eq(User.second.id)
      expect(suggestion[:authors].size).to eq(2)
      expect(suggestion[:authors][0][:id]).to eq(User.first.id)
      expect(suggestion[:authors][0][:occurances]).to eq(3)
    end

    it 'expects to find no likes or comments under post' do
        expect(Services::Suggestions.suggest(user: User.fourth)[:authors].size).to eq(0)
    end

    it 'expects failure, user does not exist' do
        expect{Services::Suggestions.suggest(user: nil)}.to raise_error(ArgumentError)
    end
  end
end
