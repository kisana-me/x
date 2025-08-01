class Account < ApplicationRecord
  has_many :posts
  has_many :reactions

  attribute :meta, :json, default: {}
  enum :status, { normal: 0, locked: 1 }

  before_create :set_aid

  validates :anyur_id,
    allow_nil: true,
    uniqueness: { case_sensitive: false }
  validates :name,
    presence: true,
    format: {
      with: S_LINE_LEGEX,
      message: "漢字必須",
      allow_blank: true
    },
    length: { in: 1..50, allow_blank: true }
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: NAME_ID_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false, allow_blank: true }
  validates :description,
    allow_blank: true,
    format: {
      with: M_LINE_LEGEX,
      message: "漢字必須"
    },
    length: {
      maximum: 100,
      too_long: "百文字以下必須"
    }
  has_secure_password

  default_scope {
    where(deleted: false)
  }

  private

end
