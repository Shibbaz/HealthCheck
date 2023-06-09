describe Types::Concepts::UserType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:email).of_type('String!') }
  it { is_expected.to have_field(:phone_number).of_type('Int!') }
  it { is_expected.to have_field(:gender).of_type('String!') }
end
