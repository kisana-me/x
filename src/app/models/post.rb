class Post < ApplicationRecord
  belongs_to :account
  belongs_to :replied, class_name: 'Post', optional: true, foreign_key: 'post_id'
  has_many :replies, class_name: 'Post', foreign_key: 'post_id'
  has_many :reactions
  before_validation :generate_name_id, on: :create
  validates :content,
    format: {
      with: K_LEGEX,
      message: "漢字必須"
    },
    length: {
      maximum: 200,
      too_long: "二百文字以下必須"
    }
  validate :check_recent_posts

  private
  def generate_name_id
    self.name_id ||= loop do
      random_id = SecureRandom.alphanumeric(14).downcase
      break random_id unless self.class.exists?(name_id: random_id)
    end
  end

  def check_recent_posts
    recent_posts_count = Post.where('created_at >= ?', 1.hour.ago).count

    if recent_posts_count >= 30
      errors.add(:base, '過去一時間以内三十件以上投稿発見、投稿作成不可')
    end
  end
end
