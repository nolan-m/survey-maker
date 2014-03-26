class CreateSurveyTakerJoinTable < ActiveRecord::Migration
  def change

    create_table :surveys_takers do |t|
      t.belongs_to :survey
      t.belongs_to :taker
    end

    remove_column :takers, :survey_id, :integer
  end
end
