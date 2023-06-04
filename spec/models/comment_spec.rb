require "rails_helper"
require "faker"

RSpec.describe Comment, type: :model do
  context "when passes sucessful" do
    it "parrams ok" do
      user = create(:user)
      post = create(:post, user_id: user.id)
      post = create(:comment, user_id: user.id, post_id: post.id)
      expect(post).to be_valid
    end
  end

  context "when does return failure" do
    it "color is not ok" do
      expect {
        create(:comment, user_id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end