class Polly

  def initialize phrase
    @phrase = phrase
  end

  def generate
    polly = Aws::Polly::Client.new
    resp = polly.synthesize_speech({
      output_format: "mp3",
      text: @phrase,
      voice_id: "Maxim",
    })
    filepath = File.join(__dir__, '../tmp/voice.mp3')
    IO.copy_stream(resp.audio_stream, filepath)
    return filepath
  end
end
