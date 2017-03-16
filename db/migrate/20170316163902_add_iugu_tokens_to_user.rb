class AddIuguTokensToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_live_token, :string
    add_column :users, :api_test_token, :string
    add_column :users, :api_user_token, :string
    add_column :users, :iugu_account_id, :string
  end
end
