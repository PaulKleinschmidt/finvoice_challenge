class FeesController < ApplicationController
  before_action :set_fee, only: %i[ show update destroy ]

  # GET /fees
  def index
    @fees = Fee.all

    render json: @fees
  end

  # GET /fees/1
  def show
    render json: @fee
  end

  # POST /fees
  def create
    @fee = Fee.new(fee_params)

    if @fee.save
      render json: @fee, status: :created, location: @fee
    else
      render json: @fee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fees/1
  def update
    if @fee.update(fee_params)
      render json: @fee
    else
      render json: @fee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fees/1
  def destroy
    @fee.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fee
      @fee = Fee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fee_params
      params.fetch(:fee, {})
    end
end
