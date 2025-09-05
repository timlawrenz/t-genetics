# frozen_string_literal: true

class AllelesController < ApplicationController
  before_action :set_allele, only: %i[show edit update destroy]

  # GET /alleles
  def index
    alleles = Allele.all
    fresh_when(alleles)
    render json: Allele.all.map(&:to_hsh)
  end

  # GET /alleles/1
  def show
    fresh_when(@allele)
    render json: @allele.to_hsh
  end

  # POST /alleles
  def create
    @allele = Allele.new(allele_params)

    if @allele.save
      render json: @allele.to_hsh, status: :created
    else
      render json: { errors: @allele.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alleles/1
  def update
    if @allele.update(allele_params)
      render json: @allele.to_hsh, status: :ok
    else
      render json: { errors: @allele.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /alleles/1
  def destroy
    @allele.destroy!
      render json: @allele.to_hsh, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_allele
    @allele = Allele.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def allele_params
    params.require(:allele).permit(:name, :chromosome_id, :inheritable_id, :inheritable_type)
  end
end
