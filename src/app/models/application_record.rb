class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  K_LEGEX = /\A[\u4E00-\u9FFF々〆〤ー「」、。！？・]+\z/
end
