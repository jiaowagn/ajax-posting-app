class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy, :like, :unlike]
  before_action :find_post, :only => [:destroy, :like, :unlike]
  def index
    @posts = Post.order("id DESC").all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
  end

  def destroy
    @post.destroy
  end

  def like
    unless @post.find_like(current_user)
      Like.create(:user => current_user, :post => @post)
    end
    redirect_to posts_path
  end

  def unlike
    like = @post.find_like(current_user)
    like.destroy
    redirect_to posts_path
  end

  protected
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content)
    end
end
