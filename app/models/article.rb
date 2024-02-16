class Article < ApplicationRecord
  validates :title, presence:true
  validates :image_path, presence:true
  validates :introduction_text, presence:true
end
