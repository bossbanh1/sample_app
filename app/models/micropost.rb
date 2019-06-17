class Micropost < ApplicationRecord
  belongs_to :user
  scope :newsfeed, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micro_lg}
  validate :picture_size

  private

  def picture_size
    return if picture.size < Settings.size_pic.megabytes

    errors.add :picture, t("error_img")
  end
end
