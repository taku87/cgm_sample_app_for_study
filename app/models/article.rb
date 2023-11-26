class Article < ApplicationRecord
  mount_uploader :image, ArticleImageUploader
end
