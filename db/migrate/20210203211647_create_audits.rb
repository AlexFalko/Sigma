class CreateAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :audits do |t|
      t.references :checklist, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
