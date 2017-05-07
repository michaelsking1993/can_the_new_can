class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :word
      t.string :pos
      t.string :inflection_form
      t.integer :frequency
      t.string :language

      t.timestamps
    end
  end
end
