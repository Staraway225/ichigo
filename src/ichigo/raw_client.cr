require "http/client"
require "uri"

class Ichigo::RawClient
  API_URL      = "https://saucenao.com"
  HTTP_HEADERS = HTTP::Headers{
    "Content-Type" => "application/json",
  }

  def initialize(@api_key : String)
  end

  def search(
    url : String? = nil,
    file : File? | String? | Path? | IO? = nil,
    mask : Int64? | String? = nil,
    exclude_mask : Int64? | String? = nil,
    site : Int32 = 999,
    testmode : Bool = false,
    result_count : Int32 = 16
  )
    raise ArgumentError.new(
      "You can't set both mask and exclude_mask. Choose one of them."
    ) if mask && exclude_mask

    client = HTTP::Client.new(URI.parse API_URL)

    form = {
      "api_key"     => @api_key,
      "output_type" => "2",
      "numres"      => result_count.to_s,
      "db"          => site.to_s,
      "testmode"    => testmode ? "1" : "0",
    }

    form["dbmask"] = mask.to_s if mask
    form["dbmaski"] = exclude_mask.to_s if exclude_mask

    if url
      form["url"] = url
      Log.info { "Sending POST request to SauceNao..." }
      response = client.post("/search.php", headers: HTTP_HEADERS, form: form)
    elsif file
      Log.info { "Sending POST request as form to SauceNao..." }
      response = send_file(form, file, client)
    else
      raise ArgumentError.new "Expected image URL or file path or file IO, but got nothing."
    end

    Log.info &.emit("Got response", status: response.status.to_s)

    parsed_response = parse(response.body)
    check_errors(parsed_response)
    parsed_response
  end

  private def send_file(form : Hash(String, String), file : String | Path, client : HTTP::Client)
    opened_file = File.new(file)
    send_file(form, opened_file, client)
  end

  private def send_file(form : Hash(String, String), file : File | IO, client : HTTP::Client)
    IO.pipe do |reader, writer|
      channel = Channel(String).new(1)

      spawn do
        HTTP::FormData.build(writer) do |formdata|
          channel.send(formdata.content_type)

          form.each do |key, value|
            formdata.field(key, value)
          end

          metadata = HTTP::FormData::FileMetadata.new(filename: "upload")
          headers = HTTP::Headers.new
          formdata.file("file", file, metadata, headers)
        end

        writer.close
      end

      headers = HTTP::Headers{"Content-Type" => channel.receive}
      client.post("/search.php", body: reader, headers: headers)
    end
  end

  private def parse(response_body : String)
    Models::GeneralResponse::Body.from_json response_body
  end

  private def check_errors(response : Models::GeneralResponse::Body)
    Log.info { "Checking response for errors..." }

    if response
      header = response.header
      unless header.status == 0
        raise Errors::ServerError.new(
          "Server responded with error: #{header.message}"
        ) if header.status > 0

        raise Errors::ClientError.new(
          "Server responded with client error: #{header.message}"
        ) if header.status < 0
      end
    end
  end
end
