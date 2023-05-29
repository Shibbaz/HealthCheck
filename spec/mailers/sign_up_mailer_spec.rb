RSpec.describe SignUpMailer, type: :mailer do
  describe '#afterwards' do
    let(:args) {
      {
        receiver: Faker::Internet.email,
        phone_number: 888888888,
        name: Faker::Name.name
      }
    }

    subject(:mailer) {
      described_class.with(args).afterwards
    }

    it 'sends an email' do
      expect(mailer.to).to eq([args[:receiver]])
    end
  end
end
