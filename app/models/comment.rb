class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :studysheet

  has_many :notifications, dependent: :destroy

end
