class GymsController < ApplicationController
  before_action :set_gym, only: %i[ show edit update destroy ]

  # GET /gyms or /gyms.json
  def index
    @gyms = Gym.all

    if params[:query].present?
      @gyms = @gyms.search_by_name_and_address(params[:query])
    end

    # user_location = nil
    if session[:latitude].present? && session[:longitude].present?
      user_location = [session[:latitude].to_f, session[:longitude].to_f]
    end

    @markers = @gyms.map do |gym|
      marker = {
        id: gym.id,
        lat: gym.latitude,
        lng: gym.longitude,
        name: gym.name
      }

      marker[:distance] = gym.distance_from(user_location) if user_location
      marker
    end

    # @markers.sort_by! { |marker| marker[:distance] || Float::INFINITY }
    @gyms = @gyms.sort_by do |gym|
      marker = @markers.find { |m| m[:id] == gym.id }
      marker[:distance] || Float::INFINITY
    end
  end

  # GET /gyms/1 or /gyms/1.json
  def show
  end

  # GET /gyms/new
  def new
    @gym = Gym.new
    @gym.build_address
    # @gym.contacts.build
  end

  # GET /gyms/1/edit
  def edit
    @gym.build_address if @gym.address.nil?
  end

  # POST /gyms or /gyms.json
  def create
    @gym = Gym.new(gym_params)

    respond_to do |format|
      if @gym.save
        format.html { redirect_to @gym, notice: "Gym was successfully created." }
        format.json { render :show, status: :created, location: @gym }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gym.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gyms/1 or /gyms/1.json
  def update
    respond_to do |format|
      if @gym.update(gym_params)
        format.html { redirect_to @gym, notice: "Gym was successfully updated." }
        format.json { render :show, status: :ok, location: @gym }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gym.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gyms/1 or /gyms/1.json
  def destroy
    @gym.destroy!

    respond_to do |format|
      format.html { redirect_to gyms_path, status: :see_other, notice: "Gym was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gym
      @gym = Gym.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gym_params
      params.require(:gym).permit(
        :name, :description, :plan, :email, :telephone, photos: [],
        address_attributes: [ :id, :street, :number, :complement, :neighborhood, :city, :state, :cep, :latitude, :longitude ]
      )
    end
end
