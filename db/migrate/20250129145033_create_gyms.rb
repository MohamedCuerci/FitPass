class CreateGyms < ActiveRecord::Migration[7.2]
  def change
    create_table :gyms do |t|
      t.string :name, null: false
      t.text :description
      t.integer :plan, null: false, default: 0

      t.timestamps
    end
  end
end
