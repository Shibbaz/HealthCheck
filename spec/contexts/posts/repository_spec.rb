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
end
