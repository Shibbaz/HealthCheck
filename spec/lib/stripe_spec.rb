require 'stripe_mock'
require 'spec_helper'

describe Services::Payments::Transfer do
        before { StripeMock.start_client }
        after { StripeMock.stop }

        it "creates stripe customer" do
            stripe_token = StripeMock.generate_card_token(number: "4242424242424242", exp_month: 10, exp_year: 2020, cvv: 123)
            customer = Stripe::Customer.create({email: 'johnny@appleseed.com', source: stripe_token})
            expect(customer.email).to eq('johnny@appleseed.com')
        end
end
