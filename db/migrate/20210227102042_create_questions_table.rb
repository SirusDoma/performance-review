# frozen_string_literal: true

class CreateQuestionsTable < ActiveRecord::Migration[6.1]
  def up
    create_table :questions do |t|
      t.text :description, null: false
      t.timestamps
      t.timestamp :deleted_at
    end
  end

  def down
    drop_table :questions
  end
end
