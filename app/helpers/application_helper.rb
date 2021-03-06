module ApplicationHelper
  def get_twitter_card_info(h)
    twitter_card = {}
    if h == 'bookranking'
      twitter_card[:url] = 'https://webookshelf.herokuapp.com/bookranking'
      twitter_card[:image] = 'https://s3-ap-northeast-1.amazonaws.com/webookshelf-production/ogps/bookranking.png'
      twitter_card[:title] = '本棚に多く入れられた本トップ20'
    elsif h == 'bookshelves'
      twitter_card[:url] = 'https://webookshelf.herokuapp.com/bookshelves'
      twitter_card[:image] = 'https://s3-ap-northeast-1.amazonaws.com/webookshelf-production/ogps/bookshelves.png'
      twitter_card[:title] = 'あなたの好きな本を検索してみよう。素敵な出会いがあるかも'
    elsif h.present?
      twitter_card[:url] = "https://webookshelf.herokuapp.com/?h=#{h}"
      twitter_card[:image] = "https://s3-ap-northeast-1.amazonaws.com/webookshelf-production/images/#{h}.png"
      name = Post.find_by(h: h).name
      name = name.present? ? name : '名無し'
      twitter_card[:title] = "#{name}さんのWeb本棚"
    else
      twitter_card[:url] = 'https://webookshelf.herokuapp.com/'
      twitter_card[:image] = 'https://s3-ap-northeast-1.amazonaws.com/webookshelf-production/images/30mlju5y.png'
      twitter_card[:title] = 'Web本棚'
    end
    twitter_card[:card] = 'summary_large_image'
    twitter_card[:description] = 'Web上で本棚を共有できるサービス'
    twitter_card
  end
end
