class PostsController < ApplicationController
  def index
    @posts = Post.order("id DESC").all
  end
end
