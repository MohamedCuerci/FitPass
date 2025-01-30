class AddfieldsToGym < ActiveRecord::Migration[7.2]
  def change
    add_column :gyms, :email, :string
    add_column :gyms, :telephone, :string
  end
end
