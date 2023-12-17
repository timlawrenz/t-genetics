# frozen_string_literal: true

class AllelesController < ApplicationController
  before_action :set_allele, only: %i[show edit update destroy]

  # GET /alleles
  def index
    @alleles = Allele.all
  end

  # GET /alleles/1
  def show; end

  # GET /alleles/new
  def new
    @allele = Allele.new
  end

  # GET /alleles/1/edit
  def edit; end

  # POST /alleles
  def create
    @allele = Allele.new(allele_params)

    if @allele.save
      redirect_to @allele, notice: 'Allele was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alleles/1
  def update
    if @allele.update(allele_params)
      redirect_to @allele, notice: 'Allele was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /alleles/1
  def destroy
    @allele.destroy!
    redirect_to alleles_url, notice: 'Allele was successfully destroyed.', status: :see_other
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
