class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :user, index: true
      t.references :goal, index: true
      t.integer :checkin_result, default: 0
      t.decimal :contribute_amount, precision: 6, scale: 2
      t.string :checkin_type, default: 'regular'
      t.string :checkin_note
      t.string :contribution_id

      t.timestamps null: false
    end

    add_foreign_key :checkins, :users
    add_foreign_key :checkins, :goals
    add_index :checkins, [:goal_id, :user_id]
  end
end