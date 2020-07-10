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
    # filename = "#{SecureRandom.hex(4)}.mp3"
    filename = "message.mp3"
    filepath = File.join(__dir__, "../tmp/public_uploads/#{filename}")
    clear_old_files
    IO.copy_stream(resp.audio_stream, filepath)

    Dir.chdir('../tmp/public_uploads')
    `avconv -i message.mp3 -f wav - | opusenc --bitrate 256 - message.opus`
    return 'message.opus'
  end

  def clear_old_files
    ["mp3", "opus"].each do |format|
      old_files = Dir.glob("#{__dir__}/../tmp/public_uploads/*.#{format}")
      FileUtils.rm_rf old_files unless old_files.empty?
    end
  end
end
