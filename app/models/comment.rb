class Comment < ApplicationRecord
  belongs_to :post_image
  belongs_to :user
  acts_as_tree order: "created_at DESC", dependent: :nullify
  belongs_to :parent, class_name: "Comment", optional: true
	has_many :childrens, class_name: "Comment", foreign_key: "parent_id"
end
