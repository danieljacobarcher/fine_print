require_dependency "fine_print/application_controller"

module FinePrint
  class AgreementsController < ApplicationController
    # GET /agreements
    # GET /agreements.json
    def index
      raise SecurityTransgression unless Agreement.can_be_listed_by?(@user)
      @agreements = Agreement.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @agreements }
      end
    end
  
    # GET /agreements/1
    # GET /agreements/1.json
    def show
      @agreement = Agreement.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @agreement }
      end
    end
  
    # GET /agreements/new
    # GET /agreements/new.json
    def new
      @agreement = Agreement.new
      raise SecurityTransgression unless @agreement.can_be_created_by?(@user)
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @agreement }
      end
    end
  
    # GET /agreements/1/edit
    def edit
      @agreement = Agreement.find(params[:id])
      raise SecurityTransgression unless @agreement.can_be_edited_by?(@user)
    end
  
    # POST /agreements
    # POST /agreements.json
    def create
      @agreement = Agreement.new(params[:agreement])
      raise SecurityTransgression unless @agreement.can_be_created_by?(@user)
      @agreement.version = (Agreement.maximum(:version, :conditions => ["name = ?", @agreement.name]) || 0) + 1
  
      respond_to do |format|
        if @agreement.save
          format.html { redirect_to @agreement, notice: 'Agreement was successfully created.' }
          format.json { render json: @agreement, status: :created, location: @agreement }
        else
          format.html { render action: "new" }
          format.json { render json: @agreement.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /agreements/1
    # PUT /agreements/1.json
    def update
      @agreement = Agreement.find(params[:id])
      raise SecurityTransgression unless @agreement.can_be_edited_by?(@user)
      if params[:agreement][:name] != @agreement.name
        @agreement.version = (Agreement.maximum(:version, :conditions => ["name = ?", params[:agreement][:name]]) || 0) + 1
      end
  
      respond_to do |format|
        if @agreement.update_attributes(params[:agreement])
          @agreement.update_attribute(:version, @agreement.version)
          format.html { redirect_to @agreement, notice: 'Agreement was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @agreement.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /agreements/1
    # DELETE /agreements/1.json
    def destroy
      @agreement = Agreement.find(params[:id])
      raise SecurityTransgression unless @agreement.can_be_destroyed_by?(@user)
      @agreement.destroy
  
      respond_to do |format|
        format.html { redirect_to agreements_url }
        format.json { head :no_content }
      end
    end
  end
end