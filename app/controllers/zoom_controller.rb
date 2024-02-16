class ZoomController < ApplicationController
    before_action :set_zoom, only: %i[ show update destroy ] 

    def index
        begin
            @zooms = Zoom.all
            render json: @zooms, status:200

        rescue => error

            render json: {error: 'サーバーエラー。'}, status: 500
        end
    end

    # GET /articles/1
    def last_article
        begin
            @zooms = Zoom.select(:id, :image_path, :title, :introduction_text, :created_at, :updated_at)
                    .order(updated_at: :asc).last
            if @zooms
            render json: @zooms, status:200
            else
            render json: {error: 'リソースが存在しません'}, status: 404
            end
        rescue => error
            render json: {error: 'サーバーエラー。'}, status: 500
        end
    end

    def show
        begin
            @zooms = Zoom.find(params[:id])
            if @zooms
            render json: @zooms, status:200
            else
            render json: {error: 'リソースが存在しません'} , status: 404
            end
        rescue => error
            render json: {error: 'サーバーエラー。'}, status: 500
        end
    end

    # POST /articles
    def create
        image_file = params[:image]
        image_path = upload_file(image_file)
        @article = Zoom.new({
            title: params[:title],
            image_path: image_path,
            introduction_text: params[:introduction_text],
            zoom_url: params[:zoom_url],
            status: 1
        })

        if @article.save
            render json: @article, status: 200
        else
            render json: @article.errors, status: 422
        end
    end

    def last_zoom
        begin
          @zooms = Zoom.where(status: 0).order(updated_at: :asc).last
          if @zooms
            render json: @zooms, status:200
          else
            render json: {error: 'リソースが存在しません'}, status: 404
          end
        rescue => error
          render json: {error: 'サーバーエラー。'}, status: 500
        end
      end

    # PATCH/PUT /articles/1
    def public
        @zooms = Zoom.find(params[:id])
        
        @zooms[:status] ^= 1 
        if @zooms.save
          @zooms = Zoom.all
          render json: @zooms.to_json(except: [ :created_at, :updated_at, :deleted_at]), status:200
          # render json: @case_study, status: 200
        else
          render json: @zooms.errors, status: 422
        end
      end

    def update
        @zoom.title = params[:title]
        # pls check Elen
        image_file = params[:image]
        @zoom.image_path = image_file ? upload_file(image_file) : params[:image_path]
        @zoom.introduction_text = params[:introduction_text]
        
        if @zoom.save
            render json: @zoom
        else
            render json: @zoom.errors.messages, status: 422
        end
    end

    # DELETE /articles/1
    def destroy
        @zoom.destroy!
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_zoom
        @zoom = Zoom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
        # params.fetch(:user, {})
        params.require(:zoom).permit!
    end

    def upload_file(file)
        # Define the specific path where you want to save the file
        ext = File.extname(file.original_filename)
        now=Time.now.strftime("%Y%m%d_%H%M%S")
        FileUtils.mkdir_p(Rails.root.join('public', 'uploads','articles')) unless
        File.directory?(Rails.root.join('public', 'uploads','articles'))
        specific_path = Rails.root.join('public', 'uploads','articles', now+ext)

        # Save the file to the specific path
        File.open(specific_path, 'wb') do |f|
        f.write(file.read)
        end
        return specific_path.to_s.split("public/")[1]
    end
end
