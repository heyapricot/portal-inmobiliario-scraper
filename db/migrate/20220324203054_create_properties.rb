class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.numeric :cost, precision: 2
      t.string :location
      t.string :bedroom_quantity
      t.string :bathroom_quantity
      t.string :link

      t.timestamps
    end
  end
end
