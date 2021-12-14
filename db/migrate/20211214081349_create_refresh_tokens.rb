class CreateRereshTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :encoded_token
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
