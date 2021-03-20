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

describe Ichigo::Client do
  Spec.before_each do
    WebMock.reset
  end

  describe "#generate_mask" do
    it "generates a 64-bit integer mask from an array of Models::Sites enum values" do
      client = Ichigo::Client.new "test"
      client.generate_mask(
        [
          Ichigo::Models::Sites::SankakuChannel,
          Ichigo::Models::Sites::AnimePictures,
        ]
      ).should eq 201326593_i64
    end

    it "generates a 64-bit integer mask from an array of 32-bit integer values" do
      client = Ichigo::Client.new "test"
      masks = (0..13).to_a
      client.generate_mask(masks).should eq 8191_i64
    end

    it "generates a 64-bit integer mask from an array of 64-bit integer values" do
      client = Ichigo::Client.new "test"
      masks = (0_i64..13_i64).to_a
      client.generate_mask(masks).should eq 8191_i64
    end
  end
end
