class BlogsController < ApplicationController

  before_action :find_blog, only: [:show, :edit, :update, :destroy]
  
  def index
    @blogs = Blog.all
    @blogs = Blog.search(params[:search]) if params[:search]
  end

  def new
    @blog = Blog.new
  end

  def show
    @blog.add_view_count
  end

  def create
    @blog = Blog.new(blog_params)
      if @blog.save
        flash[:notice] = 'Blog created successfully.'
        redirect_to @blog
      else
        flash[:error] = 'Something went wrong while saving the data.'
        render 'new'
      end
  end

  def edit
  end

  def update
    if @blog.update(params[:blog].permit(:title, :body))
      flash[:notice] = 'Blog updated successfully.'
      redirect_to @blog
    else
      flash[:error] = 'Blog cannot be updated.'
      render 'edit'
    end
  end

  def destroy
    @blog.destroy
    flash[:notice] = 'Blog deleted successfully.'
    redirect_to blogs_path
  end

  def sort
    if ['latest', 'popular', 'oldest'].include?(params[:id])
      @blogs = Blog.sort_blogs(params[:id], params[:search])
      render :index
    else
      flash[:error] = 'Something went wrong'
      redirect_to blogs_path
    end
  end


  private

    def blog_params
      params.require(:blog).permit(:title, :body)
    end

    def find_blog
      @blog = Blog.find(params[:id]) if params[:id]
    end

end
