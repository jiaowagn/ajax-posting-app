class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy, :like, :unlike, :toggle_flag]
  before_action :find_post, :only => [:destroy, :like, :unlike, :toggle_flag]
  def index
    @posts = Post.order("id DESC").limit(20)
    if params[:max_id]
      @posts = @posts.where("id < ?", params[:max_id])
    end

    respond_to do |format|
      format.html # 如果客户端要求 HTML，则回传 index.html.erb
      format.js   # 如果客户端要求 JavaScript，则回传 index.js.erb
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
  end

  def destroy
    @post.destroy
    render :json => {:id => @post.id}
  end

  def like
    unless @post.find_like(current_user)
      Like.create(:user => current_user, :post => @post)
    end
  end

  def unlike
    like = @post.find_like(current_user)
    like.destroy
    render "like"
  end

  def toggle_flag
    if current_user.is_admin?
      if @post.flag_at
        @post.flag_at = nil
      else
        @post.flag_at = Time.now
      end
      @post.save!
      render :json => {:message => "ok" ,:id => @post.id, :flag_at => @post.flag_at}
    end
  end

  protected
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content)
    end
end
