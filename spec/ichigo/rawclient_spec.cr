require "../spec_helper"

private def create_stub(body : String, error : Bool = false)
  WebMock.stub(
    :post,
    "https://saucenao.com/search.php"
  ).to_return(
    status: 200,
    body: body,
    headers: {"X-Error" => error.to_s}
  )
end

describe Ichigo::RawClient do
  Spec.before_each do
    WebMock.reset
  end

  describe "#search" do
    it "performs a search by a picture URL and returns a parsed response" do
      body = <<-RESPONSE
        {
          "header":{
              "status":0
          }
        }
      RESPONSE

      create_stub(body)

      client = Ichigo::RawClient.new "test"

      response = client.search("https://example.com/image.png")
      response.should be_a Ichigo::Models::GeneralResponse::Body
    end

    it "performs a search by a picture file path and returns a parsed response" do
      body = <<-RESPONSE
        {
          "header":{
              "status":0
          }
        }
      RESPONSE

      create_stub(body)

      client = Ichigo::RawClient.new "test"
      tempfile = File.tempfile("upload")

      response = client.search(file: tempfile.path)
      tempfile.delete
      response.should be_a Ichigo::Models::GeneralResponse::Body
    end

    it "performs a search by a picture file and returns a parsed response" do
      body = <<-RESPONSE
        {
          "header":{
              "status":0
          }
        }
      RESPONSE

      create_stub(body)

      client = Ichigo::RawClient.new "test"
      tempfile = File.tempfile("upload")

      response = client.search(file: tempfile)
      tempfile.delete
      response.should be_a Ichigo::Models::GeneralResponse::Body
    end

    it "performs a search by a picture IO and returns a parsed response" do
      body = <<-RESPONSE
        {
          "header":{
              "status":0
          }
        }
      RESPONSE

      create_stub(body)

      client = Ichigo::RawClient.new "test"
      tempfile = File.tempfile("upload")
      io = IO::Memory.new File.read(tempfile.path)

      response = client.search(file: io)
      tempfile.delete
      response.should be_a Ichigo::Models::GeneralResponse::Body
    end

    it "checks the response on a server error" do
      body = <<-RESPONSE
        {
          "header":{
              "status":1,
              "message":"This is a test server error."
          }
        }
      RESPONSE

      create_stub(body, true)

      client = Ichigo::RawClient.new "test"

      expect_raises(Ichigo::Errors::ServerError) do
        client.search("https://example.com/image.png")
      end
    end

    it "checks the response on a client error" do
      body = <<-RESPONSE
        {
          "header":{
              "status":-1,
              "message":"This is a test client error."
          }
        }
      RESPONSE

      create_stub(body, true)

      client = Ichigo::RawClient.new "test"

      expect_raises(Ichigo::Errors::ClientError) do
        client.search("https://example.com/image.png")
      end
    end

    it "doesn't allow to set both a mask and an exclude_mask" do
      client = Ichigo::RawClient.new "test"

      expect_raises(ArgumentError) do
        client.search(
          url: "https://example.com/image.png",
          mask: 8191_i64,
          exclude_mask: 8191_i64
        )
      end
    end

    it "doesn't allow to perform an empty request" do
      client = Ichigo::RawClient.new "test"

      expect_raises(ArgumentError) do
        client.search
      end
    end
  end
end
