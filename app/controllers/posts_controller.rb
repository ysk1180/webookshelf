class PostsController < ApplicationController
  def new
    # @post = Post.new
    respond_to do |format|
      format.html {}
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

  # def search
  #   keyword = params[:keyword]
  #
  #   # デバッグ出力用
  #   Amazon::Ecs.debug = true
  #
  #   # 一旦丸々コピペでテスト（あとでチューニング）
  #   books = Amazon::Ecs.item_search(
  #     params[:keyword],
  #     search_index:  'Books',
  #     dataType: 'script',
  #     response_group: 'ItemAttributes, Images',
  #     country:  'jp',
  #     power: 'Not kindle'
  #   )
  #   # 本のタイトル,画像URL, 詳細ページURLの取得
  #   @books = []
  #   books.items.each do |item|
  #     book = {
  #       title: item.get('ItemAttributes/Title'),
  #       image: item.get('LargeImage/URL'),
  #       url: item.get('DetailPageURL'),
  #     }
  #     @books << book
  #   end
  #
  #   p 1
  #   data = [@books]
  #   render :json => data
  #   # render partial: '/posts/items'
  # end

  def show
  end
end
