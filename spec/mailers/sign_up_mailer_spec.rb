# frozen_string_literal: true

RSpec.describe SignUpMailer, type: :mailer do
  describe '#afterwards' do
    let(:args) do
      {
        receiver: Faker::Internet.email,
        phone_number: 888_888_888,
        name: Faker::Name.name
      }
    end

    subject(:mailer) do
      described_class.with(args).afterwards
    end

    it 'sends an email' do
      expect(mailer.to).to eq([args[:receiver]])
    end
  end
end
