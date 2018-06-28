class AddProviderAndUidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :integer, limit: 8
  end
end
