class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :sms
      t.string :permalink
      t.boolean :activation_flag, :default => false
      t.string :activation_code
      t.string :password_digest

      t.boolean :admin, :default => false

      t.timestamps null: false
    end
  end
end
