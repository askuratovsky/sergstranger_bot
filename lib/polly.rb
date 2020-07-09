class Polly

  def initialize phrase
    @phrase = phrase
    @client = Aws::Polly::Client.new(
      region: 'eu-west-1'
    )
  end

  def generate

    resp = @client.synthesize_speech({
      output_format: "mp3",
      text: @phrase,
      voice_id: "Maxim",
    })
    filepath = File.join(__dir__, '../tmp/voice.mp3')
    IO.copy_stream(resp.audio_stream, filepath)
    return filepath
  end
end
