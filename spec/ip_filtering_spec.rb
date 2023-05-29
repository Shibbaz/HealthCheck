# frozen_string_literal: true
=begin
RSpec.describe "Tests", type: :request do
  context "Stub Remote Ip" do
    it "is forbiden to send a Request" do
      get "/tests", params: {}, env: {
        REMOTE_ADDR: "168.121.1.1"
      }, as: :json

      expect(
        request.headers["REMOTE_ADDR"]
      ).to eq("168.121.1.1")
      expect(
        response.body
      ).to eq("Your IP is not on IP While List!")
      expect(
        response.status
      ).to eq(403)
    end

    it "sends a Request" do
      get "/tests", params: {}
      expect(
        request.headers["REMOTE_ADDR"]
      ).to eq("127.0.0.1")
      expect(
        response
      ).to have_http_status(:ok)
    end
  end
end
=end
