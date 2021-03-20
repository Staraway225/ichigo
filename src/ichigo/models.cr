module Ichigo::Models
  class GeneralResponse
    class HeaderIndex
      include JSON::Serializable

      getter id : Int32?
      getter parent_id : Int32?
      getter results : Int32?
      getter status : Int32
    end

    class ResultHeader
      include JSON::Serializable

      getter index_id : Sites | Int32
      getter index_name : String
      getter similarity : String
      getter thumbnail : String
    end

    class ResultData
      include JSON::Serializable

      getter ext_urls : Array(String)?
      getter title : String?
      getter eng_name : String?
      getter jp_name : String?
      getter material : String?
      getter created_at : String?
      getter da_id : String?
      getter author_name : String?
      getter author_url : String?

      @[JSON::Field(key: "anime-pictures_id")]
      getter anime_pictures_id : String? | Int32?

      getter anidb_aid : Int32?
      getter bcy_id : Int32?
      getter bcy_type : String?
      getter danbooru_id : Int32?
      getter ddb_id : Int32?
      getter drawr_id : Int32?
      getter file : String?
      getter gelbooru_id : Int32?
      getter getchu_id : String?
      getter idol_id : Int32?
      getter imdb_id : String?
      getter konachan_id : Int32?
      getter member_link_id : Int32?
      getter mu_id : Int32?
      getter nijie_id : Int32?
      getter pawoo_id : Int32?
      getter pawoo_user_username : String?
      getter pg_id : Int32?
      getter pixiv_id : Int32?
      getter sankaku_id : Int32?
      getter seiga_id : Int32?
      getter source : String?
      getter url : String?
      getter user_acct : String?
      getter yandere_id : Int32?
      getter member_id : Int32?
      getter member_name : String?
      getter company : String?
      getter creator : Array(String)? | String?
    end

    class Result
      include JSON::Serializable

      getter header : ResultHeader
      getter data : ResultData
    end

    class Header
      include JSON::Serializable

      getter account_type : Int32? | String?
      getter index : Hash(String, HeaderIndex?)? | Array(HeaderIndex)?
      getter user_id : Int32? | String?
      getter long_limit : String?
      getter long_remaining : Int32?
      getter short_limit : String?
      getter short_remaining : Int32?
      getter message : String?
      getter minimum_similarity : Float32?
      getter query_image : String?
      getter query_image_display : String?
      getter results_requested : Int32? | String?
      getter results_returned : Int32?
      getter search_depth : String?
      getter status : Int32
    end

    class Body
      include JSON::Serializable

      getter header : Header
      getter results : Array(Result)?
    end
  end

  enum Sites
    HMagazines         =   0
    HAnimeAlt          =   1
    HGameCG            =   2
    DoujinshiDB        =   3
    DoujinshiDBSamples =   4
    PixivImages        =   5
    PixivHistorical    =   6
    AnimeAlt           =   7
    NicoNicoSeiga      =   8
    Danbooru           =   9
    DrawrImages        =  10
    NijieImages        =  11
    Yandere            =  12
    OpeningsMoe        =  13
    Shutterstock       =  15
    Fakku              =  16
    HMisc              =  18
    TwoDMarket         =  19
    MediBang           =  20
    Anime              =  21
    HAnime             =  22
    Movies             =  23
    Shows              =  24
    Gelbooru           =  25
    Konachan           =  26
    SankakuChannel     =  27
    AnimePictures      =  28
    E621               =  29
    IdolComplex        =  30
    BcyIllust          =  31
    BcyCosplay         =  32
    PortalGraphics     =  33
    DeviantArt         =  34
    Pawoo              =  35
    Madokami           =  36
    MangaDex           =  37
    HMiscEHentai       =  38
    FurAffinity        =  40
    Twitter            =  41
    FurryNetwork       =  42
    All                = 999
  end
end
