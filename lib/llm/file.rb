##
# {LLM::File LLM::File} is a class that represents a local file
# that can be used as a prompt in a chat completion request
class LLM::File
  ##
  # @return [Hash]
  #  Returns a hash of common file extensions and their
  #  corresponding MIME types
  def self.mime_types
    @mime_types ||= {
      ##
      # Images
      ".png" => "image/png",
      ".jpg" => "image/jpeg",
      ".jpeg" => "image/jpeg",
      ".webp" => "image/webp",

      ##
      # Videos
      ".flv" => "video/x-flv",
      ".mov" => "video/quicktime",
      ".mpeg" => "video/mpeg",
      ".mpg" => "video/mpeg",
      ".mp4" => "video/mp4",
      ".webm" => "video/webm",
      ".wmv" => "video/x-ms-wmv",
      ".3gp" => "video/3gpp",

      ##
      # Audio
      ".aac" => "audio/aac",
      ".flac" => "audio/flac",
      ".mp3" => "audio/mpeg",
      ".m4a" => "audio/mp4",
      ".mpga" => "audio/mpeg",
      ".opus" => "audio/opus",
      ".pcm" => "audio/L16",
      ".wav" => "audio/wav",
      ".weba" => "audio/webm",

      ##
      # Documents
      ".pdf" => "application/pdf",
      ".txt" => "text/plain"
    }.freeze
  end

  ##
  # @return [String]
  #  Returns the path to a file
  attr_reader :path

  ##
  # @param [String] path
  #  The path to a file
  # @return [LLM::File]
  def initialize(path)
    @path = path
  end

  ##
  # @return [String]
  #  Returns the MIME type of a file
  def mime_type
    self.class.mime_types[File.extname(path)]
  end

  ##
  # @return [String]
  #  Returns the contents of a file encoded in Base64
  def to_base64
    [File.binread(path)].pack("m0")
  end
end

##
# @example
# llm = LLM.gemini(key)
# bot = llm.chat LLM::File("/path/to/image.png")
# bot.chat "Describe the image"
# @param [String] path
#  The path to a file
# @return [LLM::File]
def LLM.File(path)
  LLM::File.new(path)
end
