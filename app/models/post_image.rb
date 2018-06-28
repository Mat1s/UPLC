class PostImage < ApplicationRecord
	belongs_to :post
	has_many :comments
	mount_uploader :avatar, AvatarUploader

end
