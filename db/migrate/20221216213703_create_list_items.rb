class CreateListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :list_items do |t|
      t.string :short_name
      t.text :description
      t.integer :completion_status, default: 0
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
