class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy ]

  # GET /listings or /listings.json
  def index
    @listings = Listing.all.order(created_at: :desc)
    @categories = Category.all
    
    # Category filter
    if params[:category_id].present?
      @listings = @listings.where(category_id: params[:category_id])
    end
    
    # Search functionality
    if params[:search].present?
      @listings = @listings.where("title ILIKE ? OR description ILIKE ?", 
                                   "%#{params[:search]}%", 
                                   "%#{params[:search]}%")
    end
    
    # Location filter
    if params[:location].present?
      @listings = @listings.where("city ILIKE ?", "%#{params[:location]}%")
    end
  end

  # GET /listings/1 or /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
    @categories = Category.all
  end

  # GET /listings/1/edit
  def edit
    @categories = Category.all
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user if user_signed_in?
    @categories = Category.all

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: "Listing was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy!

    respond_to do |format|
      format.html { redirect_to listings_path, notice: "Listing was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # GET /my_listings
  def my_listings
    @listings = Listing.where(user_id: current_user.id).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      base_params = params.require(:listing).permit(:title, :description, :price, :city, :category_id, 
                                                     images: [], 
                                                     :make, :model, :year, :mileage, :engine_size, 
                                                     :fuel_type, :transmission, :previous_owners, :license_plate)
      
      # Build extra_fields hash for category-specific data
      extra_fields = {}
      motors_fields = [:make, :model, :year, :mileage, :engine_size, :fuel_type, :transmission, :previous_owners, :license_plate]
      
      motors_fields.each do |field|
        if base_params[field].present?
          extra_fields[field.to_s] = base_params[field]
          base_params = base_params.except(field)
        end
      end
      
      base_params[:extra_fields] = extra_fields if extra_fields.any?
      base_params
    end
end
