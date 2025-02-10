class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :follower_count, default: 0, null: false
      t.integer :following_count, default: 0, null: false

      t.timestamps
    end
  end
end
