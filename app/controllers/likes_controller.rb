#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class LikesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  respond_to :html,
             :mobile,
             :json

  def create
    if params[:article_id]  #網誌的按贊處理
      relayable = Like.new(:positive => 1 ,
                         :target_id => params[:article_id] ,
                         :author_id => current_user.id ,
                         :target_type => "Article")
      relayable.set_guid
      relayable.initialize_signatures
      @like = relayable
      @like.save
    else
      @like = current_user.like!(target) if target rescue ActiveRecord::RecordInvalid
    end
    
    if @like
      respond_to do |format|
        format.html { render :nothing => true, :status => 201 }
        format.mobile { redirect_to post_path(@like.post_id) }
        format.json { render :json => @like.as_api_response(:backbone), :status => 201 }        
      end
    else
      render :nothing => true, :status => 422
    end
  end

  def destroy
    @like = Like.find_by_id_and_author_id!(params[:id], current_user.person.id)
    binding.pry
    current_user.retract(@like)
    respond_to do |format|
      format.json { render :nothing => true, :status => 204 }
    end
  end

  #I can go when the old stream goes.
  def index
    binding.pry
    @likes = target.likes.includes(:author => :profile)
    @people = @likes.map(&:author)

    respond_to do |format|
      format.all { render :layout => false }
      format.json { render :json => @likes.as_api_response(:backbone) }
    end
  end

  private

  def target
    if params[:article_id] 
      @target = params[:article_id]
      current_user.find_article_visible_shareable_by_id(Article, params[:article_id]) || raise(ActiveRecord::RecordNotFound.new)
    elsif params[:post_id]
      @target ||= params[:post_id]
      current_user.find_visible_shareable_by_id(Post, params[:post_id]) || raise(ActiveRecord::RecordNotFound.new)     
    else
      Comment.find(params[:comment_id]).tap do |comment|
       raise(ActiveRecord::RecordNotFound.new) unless current_user.find_visible_shareable_by_id(Post, comment.commentable_id)
      end  
    end
  end

  def like_params
    
  end

end
