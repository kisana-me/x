class Post < ApplicationRecord
  belongs_to :account
  belongs_to :replied, class_name: 'Post', optional: true, foreign_key: 'post_id'
  has_many :replies, class_name: 'Post', foreign_key: 'post_id'
  has_many :reactions

  attribute :meta, :json, default: -> { {} }
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  before_create :set_aid
  before_create :check_recent_posts

  validates :content,
    presence: true,
    length: {
      maximum: 200,
      too_long: '二百文字以下必須',
      allow_blank: true
    },
    format: {
      with: M_LINE_LEGEX,
      message: '漢字必須',
      allow_blank: true
    }

  scope :from_normal_account, -> { left_joins(:account).where(account: { status: :normal }) }
  scope :from_opened_account, -> { left_joins(:account).where(account: { visibility: :opened }) }
  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }

  private

  def check_recent_posts
    recent_count = Post
      .where(account: account)
      .includes(:posts)
      .where('posts.created_at >= ?', 1.day.ago)
      .count
    max_count = 5
    case account.subscription_plan
    when :plus then
      max_count = 10
    when :premium then
      max_count = 20
    when :luxury then
      max_count = 40
    end
    if recent_count >= max_count
      errors.add(:base, "作成制限: 二十四時間以内#{max_count}件超作成不可")
    end
  end
end
