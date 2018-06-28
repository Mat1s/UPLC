class Post < ApplicationRecord
	belongs_to :user
	has_many :post_images, dependent: :destroy
	accepts_nested_attributes_for :post_images
	acts_as_votable
end
