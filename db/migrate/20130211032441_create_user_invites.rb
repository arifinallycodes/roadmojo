class CreateUserInvites < ActiveRecord::Migration
  def change
    create_table :user_invites do |t|
      t.references :user
      t.string :email
      t.string :sign_up_token
      t.string :sign_up_source
      t.boolean :signed_up, deafult: false

      t.timestamps
    end
    add_index :user_invites, :user_id
  end
end
