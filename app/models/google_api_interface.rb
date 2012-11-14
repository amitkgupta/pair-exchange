require 'google/api_client'
class GoogleApiInterface

  def initialize
    @client = Google::APIClient.new
    @plus = @client.discovered_api('plus')
    authorize_api_client
  end

  def authorize_api_client

  end

  def get_profile_picture(email)
    result = @client.execute(
      :api_method => @plus.people.get,
      :parameters => {'userId' => email, 'fields' => 'image' }
    )

    puts result.data
  end
end