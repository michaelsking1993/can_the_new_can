class CreateGrammarConstructions < ActiveRecord::Migration[5.0]
  def change
    create_table :grammar_constructions do |t|
      t.string :formula
      t.string :language

      t.timestamps
    end
  end
end
