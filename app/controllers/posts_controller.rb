class PostsController < ApplicationController
  PER = 10

  def new
    respond_to do |format|
      format.html do
        @h = params[:h]
        @h_post = Post.find_by(h: @h) if @h.present?
        post = Post.all
        if post[-3].present?
          @posts = Post.last(3)
        elsif post[-2].present?
          @posts = Post.last(2)
        elsif post.present?
          @posts = [Post.last]
        end
        @count = post.count
      end
      format.json do
        keyword = params[:keyword]

        # デバッグ出力用
        Amazon::Ecs.debug = true

        # 一旦丸々コピペでテスト（あとでチューニング）
        books = Amazon::Ecs.item_search(
          params[:keyword],
          search_index:  'Books',
          dataType: 'script',
          response_group: 'ItemAttributes, Images',
          country:  'jp',
          power: 'Not kindle'
        )
        # 本のタイトル,画像URL, 詳細ページURLの取得
        @books = []
        books.items.each do |item|
          book = {
            title: item.get('ItemAttributes/Title'),
            image: item.get('LargeImage/URL'),
            url: item.get('DetailPageURL'),
          }
          @books << book
        end
        ret =
          {
            content: render_to_string(partial: 'posts/items.html.erb', locals: {books: @books, index_number: params[:index]}),
        }
        render json: ret
      end
    end
  end

  def index
    @posts = Post.order('created_at desc').page(params[:page]).per(PER)
    @count = Post.all.count
  end

  def make
    generate(to_uploaded(params[:imgData]), params[:hash])
    Post.create!(title1: params[:title1], image1: params[:image1], url1: params[:url1], title2: params[:title2], image2: params[:image2], url2: params[:url2], title3: params[:title3], image3: params[:image3], url3: params[:url3], title4: params[:title4], image4: params[:image4], url4: params[:url4], title5: params[:title5], image5: params[:image5], url5: params[:url5], title: params[:title], name: params[:name], twitter_id: params[:twitter_id], h: params[:hash])
    data = []
    render :json => data
  end

  def bookranking
    sql = "
    select
      count(*), books.title, books.image, books.url
    from (
      select title1 as title, image1 as image, url1 as url from posts where title1 != ''
      union all select title2 as title, image2 as image, url2 as url from posts where title2 != ''
      union all select title3 as title, image3 as image, url3 as url from posts where title3 != ''
      union all select title4 as title, image4 as image, url4 as url from posts where title4 != ''
      union all select title5 as title, image5 as image, url5 as url from posts where title5 != ''
      ) as books
    group by books.title, books.image, books.url
    order by count(*) desc
    limit 20
    "
    @books = ActiveRecord::Base.connection.select_all(sql)
  end

  private

  def to_uploaded(base64_param)
    content_type, string_data = base64_param.match(/data:(.*?);(?:.*?),(.*)$/).captures
    tempfile = Tempfile.new
    tempfile.binmode
    tempfile << Base64.decode64(string_data)
    file_param = { type: content_type, tempfile: tempfile }
    ActionDispatch::Http::UploadedFile.new(file_param)
  end

  # S3 Bucket 内に画像を作成
  def generate(image_uri, hash)
    bucket.files.create(key: png_path_generate(hash), public: true, body: image_uri)
  end

  # pngイメージのPATHを作成する
  def png_path_generate(hash)
    "images/#{hash}.png"
  end

  # bucket名を取得する
  def bucket
    # production / development / test
    environment = Rails.env
    storage.directories.get("webookshelf-#{environment}")
  end

  # storageを生成する
  def storage
    Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID_S3'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_S3'],
      region: 'ap-northeast-1'
    )
  end
end
