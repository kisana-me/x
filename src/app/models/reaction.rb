class Reaction < ApplicationRecord
  belongs_to :account
  belongs_to :post

  enum :kind, { good: 0, ok: 1, bad: 2 }
  validates :account_id,
    uniqueness: {
      scope: :post_id,
      message: "評価既存在"
    }
end
