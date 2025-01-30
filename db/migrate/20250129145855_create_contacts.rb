class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.references :gym, null: false, foreign_key: true
      t.integer :contact_type, null: false # Ex: "email", "telefone"
      t.string :value, null: false

      t.timestamps
    end
  end
end
