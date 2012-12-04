class AddTwitterSecretToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :twitter_secret, :string
  end
end
