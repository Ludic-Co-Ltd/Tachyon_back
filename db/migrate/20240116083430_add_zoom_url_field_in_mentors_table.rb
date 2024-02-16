class AddZoomUrlFieldInMentorsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :mentors, :zoom_url, :string, after: :line_url
  end
end
