class AddCepToAddress < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :cep, :string, null: false
  end
end
