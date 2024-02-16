class TestController < ApplicationController
  def welcome
    render json: 'welcome', status: 200
  end

  def file_show
    file_path = Rails.root.join('public',params[:path]+'.'+params[:format])
    # file_path = Rails.root.join('public', params[:path])
    if File.exist?(file_path) && !File.directory?(file_path)
      send_file file_path,  disposition: 'inline'
    else
      render json: { error: 'Image not found' }, status: :not_found
    end

  end
end
