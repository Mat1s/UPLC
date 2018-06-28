class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :parent_id
      t.references :post_image, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
