class CreateTables < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :twitter_user
      t.text  :text

      t.timestamps
    end

    create_table :twitter_users do |t|
      t.string :username, :oauth_token, :oauth_token_secret

      t.timestamps
    end
  end
end
