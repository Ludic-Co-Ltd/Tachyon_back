class ArticleController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ] 

  # GET /articles
  def index
    begin
      @articles = Article.all
      render json: @articles, status:200

    rescue => error

      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  # GET /articles/1
  def last_article
    begin
      @article = Article.select(:id, :image_path, :title, :introduction_text, :created_at, :updated_at)
                .order(updated_at: :asc).last
      if @article
        render json: @article, status:200
      else
        render json: {error: 'リソースが存在しません'}, status: 404
      end
    rescue => error
      render json: {error: 'サーバーエラー。'}, status: 500
    end
  end

  def show
    begin
      @article = Article.find(params[:id])
      if @article
        render json: @article, status:200
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
    @article = Article.new({
      title: params[:title],
      image_path: image_path,
      introduction_text: params[:introduction_text],
      content1: params[:content1],
      content2: params[:content2],
      subtitle:params[:subtitle]
    })

    if @article.save
      render json: @article, status: 200
    else
      render json: @article.errors, status: 422
    end
  end

  # PATCH/PUT /articles/1
  def update
    @article.title = params[:title]
    # pls check Elen
    image_file = params[:image]
    @article.image_path = image_file ? upload_file(image_file) : params[:image_path]
    @article.introduction_text = params[:introduction_text]
    @article.content1 = params[:content1]
    @article.content2 = params[:content2]
    @article.subtitle = params[:subtitle]
    if @article.save
      render json: @article
    else
      render json: @article.errors.messages, status: 422
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      # params.fetch(:user, {})
      params.require(:article).permit!
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
