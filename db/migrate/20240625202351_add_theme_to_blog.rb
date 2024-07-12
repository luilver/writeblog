class AddThemeToBlog < ActiveRecord::Migration[8.0]
  change_table(:blogs) do |t|
    t.string :theme, default: "blue", null: false
  end
end
