class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone
      t.string :phone_confirmation_code
      t.boolean :phone_confirmed, default: false

      t.timestamps
    end
  end
end
