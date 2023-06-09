RSpec.describe Concepts::Users::Queries::Details, type: :model do
    subject(:query) do
        Concepts::Users::Queries::Details.new
    end

    context 'call method' do
        before do
            FactoryBot.create_list(:user, 2)
        end

        let(:context) do
            {
                current_user: User.second
            }
        end
        
        it 'retrieves details of user by id' do
            user = User.first
            result = query.call(args: {user_id: user.id}, context: context)
            expect(result.id).to eq(user.id)
            expect(result.name).to eq(user.name)
            expect(result.email).to eq(user.email)
            expect(result.phone_number).to eq(user.phone_number)
        end

        it 'retrieves details of current user' do
            user = User.second
            result = query.call(args: {user_id: nil}, context: context)
            expect(result.id).to eq(user.id)
            expect(result.name).to eq(user.name)
            expect(result.email).to eq(user.email)
            expect(result.phone_number).to eq(user.phone_number)
        end

        it 'fails to retrieve details of user, user does not exist' do
            expect{ 
                query.call(args: {user_id: SecureRandom.uuid}, context: context)
            }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end