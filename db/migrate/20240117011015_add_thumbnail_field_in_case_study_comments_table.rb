class AddThumbnailFieldInCaseStudyCommentsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :case_study_comments, :thumbnail, :string, after: :file_path
  end
end
