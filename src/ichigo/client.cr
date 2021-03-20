class Ichigo::Client
  def initialize(@api_key : String)
  end

  def search(
    url : String? = nil,
    file : File? | String? | Path? | IO? = nil,
    mask : Array(Models::Sites)? | Array(Int32)? | Array(Int64)? = nil,
    exclude_mask : Array(Models::Sites)? | Array(Int32)? | Array(Int64)? = nil,
    site : Models::Sites | Int32 = Models::Sites::All,
    testmode : Bool = false,
    result_count : Int32 = 16
  )
    generated_mask = generate_mask(mask) if mask
    generated_exclude_mask = generate_mask(exclude_mask) if exclude_mask
    site = site.is_a?(Models::Sites) ? site.to_i : site

    raw_client = RawClient.new(@api_key)

    raw_client.search(url, file, generated_mask, generated_exclude_mask, site, testmode, result_count)
  end

  def generate_mask(masks : Array(Models::Sites) | Array(Int32)) : Int64
    masks = masks.map &.to_i64
    generate_mask(masks)
  end

  # Seems to be working properly with indexes above 10. Looking into fixes.
  def generate_mask(masks : Array(Int64)) : Int64
    masks.reduce(1_i64) { |acc, i| acc ^ ("1" + "0" * (i <= 0 ? i : i - 1)).to_i64 2 }
  end
end
