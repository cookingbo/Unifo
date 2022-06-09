class Public::HomesController < ApplicationController


  def top
    @posts = Post.order("created_at desc")
  end

  def about
  end
end
