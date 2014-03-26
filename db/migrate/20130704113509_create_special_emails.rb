class CreateSpecialEmails < ActiveRecord::Migration
  def change
    create_table :special_emails do |t|
      t.string :email

      t.timestamps
    end
  end
end
