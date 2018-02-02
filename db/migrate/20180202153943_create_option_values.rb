class CreateOptionValues < ActiveRecord::Migration[5.2]
  def change
    create_table :option_values do |t|
      t.references :option_type, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
