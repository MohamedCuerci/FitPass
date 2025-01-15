class CreateStripeEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :stripe_events do |t|
      t.string :stripe_id
      t.string :event_type
      t.string :status
      t.jsonb :metadata

      t.timestamps
    end
  end
end
