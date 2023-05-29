require 'sidekiq/testing'

RSpec.describe MailerJob, type: :mailer do
    describe '#perform' do
        before do
            Sidekiq::Testing.fake!
        end

        let(:args){

            {
                email: Faker::Internet.email,
                phone_number: 888888888,
                name: Faker::Name.name
            }
        }

        subject(:acidic_job){
            AcidicJob::Run
        }

        it 'is valid' do
            described_class.with().perform(args)
            expect(acidic_job.count).to eq(1)
            mailer_run = acidic_job.first
            expect(mailer_run.serialized_job["queue_name"]).to eq("mailer")
            expect(mailer_run.workflow["send_email"]["then"]).to eq("FINISHED")
        end 
    end
end
