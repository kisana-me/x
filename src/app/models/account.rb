class Account < ApplicationRecord
  has_many :posts
  has_many :reactions
  before_validation :generate_name_id, on: :create
  before_validation :generate_login_password, on: :create
  validates :name,
    format: {
      with: S_LINE_LEGEX,
      message: "漢字必須"
    },
    length: {
      maximum: 20,
      too_long: "二十文字以下必須"
    }
  validates :bio,
    format: {
      with: M_LINE_LEGEX,
      message: "漢字必須"
    },
    length: {
      maximum: 100,
      too_long: "百文字以下必須"
    },
    allow_blank: true

  private

  def generate_name_id
    self.name_id ||= loop do
      random_id = SecureRandom.alphanumeric(14).downcase
      break random_id unless self.class.exists?(name_id: random_id)
    end
  end
  def generate_login_password
    self.login_password ||= loop do
      random_id = SecureRandom.alphanumeric(14).downcase
      break random_id unless self.class.exists?(login_password: random_id)
    end
  end
end
