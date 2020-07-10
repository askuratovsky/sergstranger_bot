class Polly

  def initialize config, phrase
    @phrase = phrase
    @client = Aws::Polly::Client.new(
      region: 'eu-west-1',
      credentials: Aws::Credentials.new(config["aws"]["key_id"], config["aws"]["access_key"])
    )
  end

  def generate
    resp = @client.synthesize_speech({
      output_format: "mp3", # value set: [ogg_vorbis, json, mp3, pcm]
      text: @phrase,
      voice_id: "Maxim"
    })
    filename = 'message.mp3'
    filepath = File.join(__dir__, "../tmp/public_uploads/#{filename}")
    IO.copy_stream(resp.audio_stream, filepath)
    return filename
  end
end
