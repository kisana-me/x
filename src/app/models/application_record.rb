class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include TokenTools

  private

  NAME_ID_REGEX = /\A[a-zA-Z0-9_]+\z/
  M_LINE_LEGEX = /\A[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+(?:\n+[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+){0,8}\z/
  S_LINE_LEGEX = /\A[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+\z/

  def set_aid
    self.aid ||= SecureRandom.base36(14)
  end
end
