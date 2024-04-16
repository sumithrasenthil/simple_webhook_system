class CreateWebhookDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_details do |t|
      t.text :end_point
      t.string :secret
      t.boolean :active
      t.integer :event_type

      t.timestamps
    end
  end
end
