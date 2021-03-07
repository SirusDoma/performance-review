# frozen_string_literal: true

class CreateEmployeesTable < ActiveRecord::Migration[6.1]
  def up
    create_table :employees do |t|
      t.string  :full_name,       null: false
      t.string  :email,           null: false
      t.string  :password_digest, null: false
      t.integer :gender,          null: false, default: 0
      t.string  :department,      null: false
      t.string  :phone_number,    null: false
      t.text    :address,         null: false
      t.boolean :is_admin,        null: false, default: false
      t.timestamps

      t.index :full_name
      t.index :department
      t.index :email
    end
  end

  def down
    drop_table :employees
  end
end
