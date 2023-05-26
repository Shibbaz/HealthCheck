require "rails_helper"
require "faker"

RSpec.describe Contexts::Helpers::Versioning, type: :model do
  subject(:repository) {
    Contexts::Helpers::Versioning
  }
  context "create method" do
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

    let(:extra_post) {
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: []
      )
    }

    it "it success" do
      post.update(insights: "Text")
      post.reload
      expect(Contexts::Helpers::Versioning.versions(post.log_data).size).to eq(1)

      post.update(question: "What is my purpose?")
      post.reload
      expect(Contexts::Helpers::Versioning.versions(post.log_data).size).to eq(2)
    end

    it "it fails" do
      expect {
        Contexts::Helpers::Versioning.versions(extra_post.log_data)
      }.to raise_error(Contexts::Helpers::Errors::VersionsNotFoundError)
    end
  end
end
