class Studysheet < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :user

  # CommentモデルのAssociationを設定
  has_many :comments, dependent: :destroy

  mount_uploader :image, ImageUploader
end
