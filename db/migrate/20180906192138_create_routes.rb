class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.text :description
      t.integer :route_role
      t.integer :seats, default: 1
      t.timestamps
    end
  end
end
