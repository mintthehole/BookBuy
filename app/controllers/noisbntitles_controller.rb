class NoisbntitlesController < ApplicationController
  def index
    unless params[:queryTitleID].blank?
      @enrichedtitle = Enrichedtitle.find_by_title_id(params[:queryTitleID])      
      if @enrichedtitle.nil?
        @noisbntitle = Noisbntitle.find_by_title_id(params[:queryTitleID])
        respond_to do |format|
          unless @noisbntitle.nil?
            format.html {render "show"}
            format.js {render :json => @noisbntitle}
          else
            format.html {render :not_found}
            format.js {head :not_found}
          end
        end
      else
        respond_to do |format|
          format.html {render :enrichedtitle_found}
          format.js {head :forbidden}
        end
      end
    end
  end
    
  def create
    @noisbntitle = Noisbntitle.new(params[:noisbntitle])

    if @noisbntitle.save
      redirect_to(@noisbntitle, :notice => 'Title was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def new
    @noisbntitle = Noisbntitle.new_from_title(params[:titleid])
  end  
  
  def show
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def edit
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def update
    @noisbntitle = Noisbntitle.find(params[:id])

    if @noisbntitle.update_attributes(params[:noisbntitle])
      flash[:success] = 'Successfully updated.'
      redirect_to(@noisbntitle) 
    else
      render :action => "edit"
    end
  end  
end