# frozen_string_literal: true

class CreateReviewsTable < ActiveRecord::Migration[6.1]
  def up
    create_table :reviews do |t|
      t.references :assignment, null: false, foreign_key: { to_table: :assignments }
      t.references :question,   null: false, foreign_key: { to_table: :questions }
      t.text :answer,           null: false
      t.timestamps

      t.index %i[assignment_id question_id], unique: true
    end
  end
end
