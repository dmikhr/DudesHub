class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos do |t|
      t.string :full_name, null: false
      t.integer :repo_id, null: false
      t.boolean :monitored, null: false, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
