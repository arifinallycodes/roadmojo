class AddFbAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_authentication_token, :string
  end
end
