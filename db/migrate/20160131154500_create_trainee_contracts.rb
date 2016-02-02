class CreateTraineeContracts < ActiveRecord::Migration
  def change
    create_table :trainee_contracts do |t|
      t.references :scholarship, index: true
      t.string :signature_id
      t.text :status
      t.boolean :signed, default: false

      t.timestamps
    end
    add_index :trainee_contracts, :signature_id
  end
end
