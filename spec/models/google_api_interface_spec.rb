require 'spec_helper'

describe GoogleApiInterface do
  describe '#initialize' do
    it 'authenticates the client with our google API auth stuff' do
      mock_client = double(:client)
      #mock_client.should_receive(:discovered_api).with('plus')
      Google::APIClient.should_receive(:new).and_return(mock_client)
      GoogleApiInterface.any_instance.should_receive(:authorize_api_client)

      GoogleApiInterface.new
    end
  end

  describe '#authorize_api_client' do
    it 'authorizes the api client'
  end

  describe '#get_profile_picture' do
    let(:email) { 'owner@pivotallabs.com' }

    it 'returns the image url for the given email address' do
      url = %r{https://www.googleapis.com/plus/v1/people/#{email}}
      photo_request = stub_request(:get, url).with(fields: 'image')

      GoogleApiInterface.new.get_profile_picture(email)

      photo_request.should have_been_requested
    end
  end
end