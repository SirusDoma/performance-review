# frozen_string_literal: true

class CreateAssignmentsTable < ActiveRecord::Migration[6.1]
  def up
    create_table :assignments do |t|
      t.references :reviewer, null: false, foreign_key: { to_table: :employees }
      t.references :reviewee, null: false, foreign_key: { to_table: :employees }
      t.references :creator,  null: false, foreign_key: { to_table: :employees }
      t.timestamps

      t.index %i[id reviewer_id reviewee_id], unique: true
    end
  end

  def down
    drop_table :assignments
  end
end
