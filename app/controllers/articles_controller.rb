class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        # Cloudinaryでファイルをアップロードおよび加工する処理
        uploaded_image = Cloudinary::Uploader.upload(params[:article][:image].tempfile.path,
          transformation: [
            {
              overlay: "text:Arial_200_bold:#{@article.title}", # テキストのオーバーレイ
              color: "orange", # テキストの色
              gravity: "north_west", # テキストの位置（左上）
              y: 50, # テキストのy位置の微調整
              x: 50  # テキストのx位置の微調整
            },
            {
              overlay: "runtequn_twinap", # cloudinaryにアップロードしている画像のPublicIDを指定
              gravity: "south_east", # 位置
              width: 433, # 幅を指定（任意）
              height: 736, # 高さを指定（任意）
              y: 50, # 位置の微調整（任意）
              x: 100 # 位置の微調整（任意）
            }
          ]
        )

        # アップロードしたファイルのURLを取得
        cloudinary_url = uploaded_image["url"]

        # ArticleモデルにURLを保存
        @article.remote_image_url = cloudinary_url

        # CarrierWaveのアップローダーオブジェクトを保存
        @article.save

        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :image)
    end
end
