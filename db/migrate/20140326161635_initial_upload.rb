class InitialUpload < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.column :name, :string
    end

    create_table :questions do |t|
      t.column :name, :string
      t.belongs_to :survey
    end

    create_table :answers do |t|
      t.column :name, :string
      t.belongs_to :question
    end

    create_table :takers do |t|
      t.column :name, :string
      t.belongs_to :survey
    end

    create_table :responses do |t|
      t.belongs_to :taker
      t.belongs_to :question
      t.belongs_to :answer
    end
  end
end
