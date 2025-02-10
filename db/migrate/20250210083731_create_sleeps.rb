class CreateSleeps < ActiveRecord::Migration[8.0]
  def change
    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in, index: true
      t.datetime :clock_out, index: true

      t.timestamps
    end

    add_index :sleeps, [ :user_id, :clock_in ]
    add_index :sleeps, [ :user_id, :clock_out ]
  end
end
