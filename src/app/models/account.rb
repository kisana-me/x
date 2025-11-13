class Account < ApplicationRecord
  has_many :sessions
  has_many :posts
  has_many :reactions
  has_many :oauth_accounts

  attribute :meta, :json, default: -> { {} }
  enum :visibility, { closed: 0, limited: 1, opened: 2 }, default: :opened
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  before_create :set_aid

  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true },
    format: {
      with: S_LINE_LEGEX,
      message: "漢字必須",
      allow_blank: true
    }
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: NAME_ID_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false, allow_blank: true }
  validates :description,
    allow_blank: true,
    length: {
      maximum: 100,
      too_long: "百文字以下必須"
    },
    format: {
      with: M_LINE_LEGEX,
      message: "漢字必須"
    }
  has_secure_password validations: false
  validates :password,
    allow_blank: true,
    length: { in: 8..30 },
    confirmation: true

  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }
  scope :is_opened, -> { where(visibility: :opened) }
  scope :isnt_closed, -> { where.not(visibility: :closed) }

  def subscription_plan
    status = meta.dig("subscription", "subscription_status")
    return :basic unless %w[active trialing].include?(status)

    period_end = meta.dig("subscription", "current_period_end")&.to_time
    return :expired unless period_end && period_end > Time.current

    plan = meta.dig("subscription", "plan")
    plan&.to_sym || :unknown
  end

  def valid_anyur_account
    oauth_accounts.find_by(provider: :anyur, status: :normal)
  end

  def admin?
    self.meta["roles"]&.include?("admin")
  end

  private
end
