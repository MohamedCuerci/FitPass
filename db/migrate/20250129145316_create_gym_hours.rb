class CreateGymHours < ActiveRecord::Migration[7.2]
  def change
    create_table :gym_hours do |t|
      t.references :gym, null: false, foreign_key: true
      t.integer :day_of_week, null: false # 0 = Domingo, 6 = Sábado
      t.time :opening_time, null: false
      t.time :closing_time, null: false

      t.timestamps
    end
  end
end
