class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.string :name,    null: false
      t.string :project
      t.string :image
      t.string :email,   null: false
      t.string :phone
      t.string :job
      t.string :linkedin
      t.string :address

      t.timestamps
    end
  end
end
