class GymHoursController < ApplicationController
  before_action :set_gym_hour, only: %i[ show edit update destroy ]

  # GET /gym_hours or /gym_hours.json
  def index
    @gym_hours = GymHour.all
  end

  # GET /gym_hours/1 or /gym_hours/1.json
  def show
  end

  # GET /gym_hours/new
  def new
    @gym_hour = GymHour.new
  end

  # GET /gym_hours/1/edit
  def edit
  end

  # POST /gym_hours or /gym_hours.json
  def create
    @gym_hour = GymHour.new(gym_hour_params)

    respond_to do |format|
      if @gym_hour.save
        format.html { redirect_to @gym_hour, notice: "Gym hour was successfully created." }
        format.json { render :show, status: :created, location: @gym_hour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gym_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gym_hours/1 or /gym_hours/1.json
  def update
    respond_to do |format|
      if @gym_hour.update(gym_hour_params)
        format.html { redirect_to @gym_hour, notice: "Gym hour was successfully updated." }
        format.json { render :show, status: :ok, location: @gym_hour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gym_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gym_hours/1 or /gym_hours/1.json
  def destroy
    @gym_hour.destroy!

    respond_to do |format|
      format.html { redirect_to gym_hours_path, status: :see_other, notice: "Gym hour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gym_hour
      @gym_hour = GymHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gym_hour_params
      params.require(:gym_hour).permit(:gym_id, :day_of_week, :opening_time, :closing_time)
    end
end
