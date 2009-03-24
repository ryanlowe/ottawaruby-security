class ItemController < ApplicationController
  
  def list
    @items = Item.find(:all,:order => 'id DESC')
    @title = "Items"
  end
  
  def search
    if params[:q].blank?
      @title = "Search Items"
    else
      @items = Item.search_for_name(params[:q])
      @title =  "Items containing #{params[:q]}"
    end
  end
  
  def create
    @item = Item.new(params[:item])
    @item.creator = current_user
    if @item.save
      flash[:notice] = "Item added"
    else
      flash[:notice] = "Item not added: "+@item.errors.full_messages.join(", ")
    end
    redirect_to :action => 'list'
  end
  
end
