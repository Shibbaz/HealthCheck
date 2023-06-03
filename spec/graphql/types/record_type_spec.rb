describe Types::RecordType do
    subject { described_class }
  
    it { is_expected.to have_field(:likes).of_type("[User!]!") }
    it { is_expected.to have_field(:likes_counter).of_type("Int!") }
    it { is_expected.to have_field(:versions).of_type("[JSON!]!") }
    it { is_expected.to have_field(:created_at).of_type("ISO8601DateTime!") }
    it { is_expected.to have_field(:updated_at).of_type("ISO8601DateTime!") }
end
  