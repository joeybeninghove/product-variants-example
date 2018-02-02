class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.string :sku
      t.monetize :price
      t.boolean :is_master
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
