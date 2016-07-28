require 'spec_helper'

describe Hyperwallet::User do

  let!(:api) { Hyperwallet.mock_rest_client = double('RestClient') }
  let(:user) { TestData.user }

  describe ".all" do
    it "should call the api" do
      expect(api).to receive(:get)
        .with(Hyperwallet.api_url("/users"), nil, nil)
        .and_return(test_response([user]))
      Hyperwallet::User.all
    end
  end

  describe ".find" do
    it "should call the api" do
      expect(api).to receive(:get)
        .with(Hyperwallet.api_url("/users/user_id_1"), nil, nil)
        .and_return(test_response(user))
      Hyperwallet::User.find("user_id_1")
    end
  end

  describe ".create" do
    it "should call the api" do
      expect(api).to receive(:post)
        .with(Hyperwallet.api_url('/users'), nil, user.to_json)
        .and_return(test_response(user))
      Hyperwallet::User.create(user)
    end
  end

  describe ".update" do
    it "should call the api" do
      expect(api).to receive(:put)
        .with(Hyperwallet.api_url("/users/user_key_1"), nil, "{\"firstName\":\"Jonathan\"}").
        and_return(test_response(user))
      Hyperwallet::User.update("user_key_1", :firstName => "Jonathan")
    end
  end

  # Not yet implemented in REST API
  # describe ".delete" do
  #   it "should call the api" do
  #     expect(api).to receive(:delete)
  #       .with(Hyperwallet.api_url('/users/user_key_1'), nil, nil)
  #       .and_return(test_response(user))

  #     Hyperwallet::User.delete("user_key_1")
  #   end
  # end

end
