namespace :onetime do
  task migration: :environment do
    Post.all.each do |post|
      book_titles = [post.title1, post.title2, post.title3, post.title4, post.title5].compact.uniq.reject(&:blank?)
      next if book_titles.empty?

      bookshelf = Bookshelf.create!(title: post.title, user_name: post.name, h: post.h, twitter_id: post.twitter_id)

      book_titles.each do |book_title|
        request = Vacuum.new(marketplace: 'JP',
                             access_key: ENV['AMAZON_API_ACCESS_KEY'],
                             secret_key: ENV['AMAZON_API_SECRET_KEY'],
                             partner_tag: ENV['ASSOCIATE_TAG'])
        response = request.search_items(keywords: book_title,
                                        search_index: 'Books',
                                        resources: ['ItemInfo.Title', 'Images.Primary.Large', 'ItemInfo.ContentInfo']).to_h
        items = response.dig('SearchResult', 'Items')

        item = items[0]

        asin = item.dig('ASIN')
        book = Book.find_by(asin: asin)

        if book.present?
          BookshelfBook.create!(book_id: book.id, bookshelf_id: bookshelf.id)
          next
        end

        row_release_data = item.dig('ItemInfo', 'ContentInfo', 'PublicationDate', 'DisplayValue')
        book = Book.create!(
          asin: asin,
          title: item.dig('ItemInfo', 'Title', 'DisplayValue'),
          image: item.dig('Images', 'Primary', 'Large', 'URL'),
          url: item.dig('DetailPageURL'),
          page: item.dig('ItemInfo', 'ContentInfo', 'PagesCount', 'DisplayValue'),
          released_at: Date.parse(row_release_data).strftime("%Y/%m/%d")
        )
        BookshelfBook.create!(book_id: book.id, bookshelf_id: bookshelf.id)

        sleep(1)
      end
    end
  end
end