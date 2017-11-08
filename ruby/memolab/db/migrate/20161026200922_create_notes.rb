class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.belongs_to :user,      index: true, null: false
      t.belongs_to :candidate, index: true, null: false
      
      t.string  :message, null: false
      t.boolean :edited,  default: false
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
