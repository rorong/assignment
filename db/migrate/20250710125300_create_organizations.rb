class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
