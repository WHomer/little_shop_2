class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :description
      t.float :discount
      t.integer :qualifier_quantitiy
      t.integer :qualifier_value
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
