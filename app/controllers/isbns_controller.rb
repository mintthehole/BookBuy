class IsbnsController < ApplicationController
  def new
    @isbn = Isbn.new
  end
  
  def create
    @isbn = Isbn.new(params[:isbn])
    if @isbn.valid?
      render :action => :show
    else
      flash[:error] = 'Invalid ISBN'
      render :action => :new
    end
  end
end