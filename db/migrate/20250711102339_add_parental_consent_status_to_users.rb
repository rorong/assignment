class AddParentalConsentStatusToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :parental_consent_status, :integer, default: 0
    add_column :users, :parental_consent_token, :string
    add_column :users, :parental_consent_approved_at, :datetime

    add_index :users, :parental_consent_token, unique: true
  end
end

