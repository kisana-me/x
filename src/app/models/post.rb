class Post < ApplicationRecord
  belongs_to :account
  belongs_to :replied, class_name: 'Post', optional: true, foreign_key: 'post_id'
  has_many :replies, class_name: 'Post', foreign_key: 'post_id'
  has_many :reactions

  attribute :meta, :json, default: {}
  enum :status, { normal: 0, locked: 1 }

  before_create :set_aid

  validates :content,
    presence: true,
    format: {
      with: M_LINE_LEGEX,
      message: "漢字必須",
      allow_blank: true
    },
    length: {
      maximum: 200,
      too_long: "二百文字以下必須",
      allow_blank: true
    }
  validate :check_recent_posts

  default_scope {
    includes(:account)
      .where(deleted: false, account: { deleted: false })
  }

  private

  def check_recent_posts
    recent_posts_count = Post.where("account.created_at >= ?", 1.hour.ago).count

    if recent_posts_count >= 30
      errors.add(:base, "過去一時間以内三十件以上投稿発見、投稿作成不可")
    end
  end
end
