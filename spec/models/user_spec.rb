require "rails_helper"
require "faker"

RSpec.describe User, type: :model do
  context "when passes sucessful" do
    it "parrams ok" do
      user = create(:user, name: Faker::Name.name, email: Faker::Internet.email, password_digest: Faker::Internet.password, id: SecureRandom.uuid, avatar_id: nil, is_admin: false)
      expect(user).to be_valid
    end
  end

  context "when does return failure" do
    it "email is not ok" do
      expect {
        create(:user,
               name: Faker::Name.name,
               email: Faker::Internet.email,
               password_digest: Faker::Internet.password,
               id: SecureRandom.uuid,
               archive: false,
               phone_number: 6,
               is_admin: false)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end