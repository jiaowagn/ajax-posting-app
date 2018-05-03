class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy, :like, :unlike, :toggle_flag, :rate]
  before_action :find_post, :only => [:destroy, :like, :unlike, :toggle_flag, :update, :rate]
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

  def update
    # 是本地开发，感觉可能会一闪而过，我们可以暂时故意地在 action 做延迟,但这只是看看效果，试完请移除掉。
    # sleep(1)
    @post.update!(post_params)
    render :json => {:id => @post.id, :message => "ok"}
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

  def rate
    existing_score = @post.find_score(current_user)
    if existing_score
      existing_score.update(:score => params[:score])
    else
      @post.scores.create(:score => params[:score], :user => current_user)
    end
    render :json => { :average_score => @post.average_score }
  end

  protected
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :category_id)
    end
end
