class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :gym, null: false, foreign_key: true
      t.string :street, null: false
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city, null: false
      t.string :state, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
