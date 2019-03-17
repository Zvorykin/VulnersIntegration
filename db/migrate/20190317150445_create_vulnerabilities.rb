class CreateVulnerabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :vulnerabilities do |t|
      t.string :uid, null: false, index: true
      t.string :name, null: false, index: true
      t.integer :level_id, null: false
      t.text :description
      t.string :remediation

      t.timestamps
    end
  end
end
