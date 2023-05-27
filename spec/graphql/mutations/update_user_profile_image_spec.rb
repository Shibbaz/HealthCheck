require "rails_helper"

RSpec.describe Mutations::UpdateUserProfileImageMutation, type: :request do
  let(:image) {
    fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "image.jpg"), "image/jpg")
  }
  let(:txt) {
    fixture_file_upload(Rails.root.join("spec", "fixtures", "file.txt"), "txt")
  }
  let(:user) {
    User.create(email: Faker::Internet.email, password_digest: "test", phone_number: 667089810, name: "test")
  }

  describe ".mutation passes" do
    it "uploads new avatar" do
      expect { Mutations::UpdateUserProfileImageMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
        id: user.id,
        file: image
      ) }.to_not raise_error
      user.reload
      expect(user.avatar_id).to_not be(nil)
      expect { $s3.get_object(bucket: "files", key: user.avatar_id) }.to_not raise_error
    end

    it "cannot upload new avatar" do
        expect {
            Mutations::UpdateUserProfileImageMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
                id: user.id,
                file: txt
            )
        }.to raise_error(Contexts::Helpers::Errors::FileInvalidTypeError)
      end
  end
end