# -*- encoding : utf-8 -*-
class BlogController < ApplicationController

  def index
    @posts = Post.joins(:book).includes(:book => { :participations => [:person, :role] }).where("books.publisher_id = #{session[:publisher]}").order("created_at desc")
  end

  def show
    @post = Post.includes(:book => { :participations => [:person, :role] }).find(params[:id])
  end
end
