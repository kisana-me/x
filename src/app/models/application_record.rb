class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  M_LINE_LEGEX = /\A[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+(?:\n+[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+){0,8}\z/

  S_LINE_LEGEX = /\A[\u4E00-\u9FFF々〆〤ー「」、。！？＃％（）・]+\z/
end
