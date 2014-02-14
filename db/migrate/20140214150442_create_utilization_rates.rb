class CreateUtilizationRates < ActiveRecord::Migration
  def change
    create_table :utilization_rates do |t|
      t.date :shift_date
      t.decimal :total_utilization_rate, :precision => 11, :scale => 2, :default => 0.0
      t.integer :person_id
      t.timestamps
    end
  end
end
