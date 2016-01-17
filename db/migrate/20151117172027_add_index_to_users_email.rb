class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :permalink
    add_index :users, :email
    add_column :users, :remember_token, :string
  end
end
