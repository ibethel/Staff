class ArticlesController < ApplicationController
  
  # GET /articles
  # GET /articles.xml
  def index
    @user = User.find(params[:user_id])
    @articles = @user.articles
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    @title = "New Article"
  end

  # GET /articles/1/edit
  def edit
    @article = Article.belongs_to_user(current_user).find(params[:id])
    @title = @article.title
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to([current_user, @article], :notice => 'Your article has been posted') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.belongs_to_user(current_user).find(params[:id])
    
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.belongs_to_user(current_user).find(params[:id])

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
