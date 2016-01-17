class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :permalink
      t.references :user, index: true
      t.string :goal_type
      t.string :short_description
      t.text :long_description
      t.string :reminder_frequency
      t.decimal :deserve_amount, precision: 6, scale: 2
      t.string :reward_type
      t.string :reward
      t.string :reward_link
      t.decimal :amount_needed
      t.integer :goal_status, default: 'incomplete'

      t.timestamps null: false
    end

    add_foreign_key :goals, :users
    add_index :goals, [:user_id, :permalink, :goal_status]
  end
end