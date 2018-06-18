class AddDeviseConfirmationToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
       t.string   :unconfirmed_email
    end
  end
end
