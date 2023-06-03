describe Types::SubscriptionType do
    describe 'subposts' do
      subject { 
        Types::SubscriptionType.fields['notificationWasSent'] }
  
      it 'accepts an ID argument' do
        expect(subject).to accept_argument(:user_id).of_type('ID!')
      end
    end
  end