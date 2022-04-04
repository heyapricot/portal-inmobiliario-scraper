class AddCurrencyToProperties < ActiveRecord::Migration[7.0]
  def up
    create_enum :currency, %w[clp uf]

    add_column :properties, :currency, :enum, enum_type: :currency
  end

  def down
    remove_column :properties, :currency
    execute 'DROP TYPE currency'
  end
end
