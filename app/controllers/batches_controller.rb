class BatchesController < ApplicationController
  # GET /batches
  # GET /batches.xml
  def index
    @batches = Batch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @batches }
    end
  end

  # GET /batches/1
  # GET /batches/1.xml
  def show
    @batch = Batch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @batch }
    end
  end

  # GET /batches/new
  # GET /batches/new.xml
  def new
    @batch = Batch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @batch }
    end
  end

  # GET /batches/1/edit
  def edit
    @batch = Batch.find(params[:id])
  end

  # POST /batches
  # POST /batches.xml
  def create
    @batch = Batch.new(params[:batch])
    respond_to do |format|
      retval = plsql.FN_CAN_CREATE_NEW_BATCH(Batch.current_batch.first.id)
      if(retval == 0)    
        if @batch.save
          format.html { redirect_to(@batch, :notice => 'Batch was successfully created.') }
          format.xml  { render :xml => @batch, :status => :created, :location => @batch }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @batch.errors, :status => :unprocessable_entity }
        end
      else
        if(retval == 1)
          flash[:error] = "Current Batch ID is not valid!"
        elsif
          flash[:error] = "Current Batch still has capacity!"
        end
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /batches/1
  # PUT /batches/1.xml
  def update
    @batch = Batch.find(params[:id])

    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.html { redirect_to(@batch, :notice => 'Batch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @batch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1
  # DELETE /batches/1.xml
  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to(batches_url) }
      format.xml  { head :ok }
    end
  end
end
