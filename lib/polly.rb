require 'securerandom'
require 'fileutils'
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
    filename = "#{SecureRandom.hex(4)}.mp3"
    filepath = File.join(__dir__, "../tmp/public_uploads/#{filename}")
    old_files = Dir.glob("#{__dir__}/../tmp/public_uploads/*.mp3")
    FileUtils.rm_rf old_files unless old_files.empty?
    IO.copy_stream(resp.audio_stream, filepath)
    return filename
  end
end
