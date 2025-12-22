# frozen_string_literal: true

class AllelesController < ApplicationController
  before_action :set_allele, only: %i[show edit update destroy]

  # GET /alleles
  def index
    @alleles = Allele.all
    fresh_when(@alleles)

    respond_to do |format|
      format.html
      format.json { render json: @alleles.map(&:to_hsh) }
    end
  end

  # GET /alleles/1
  def show
    fresh_when(@allele)

    respond_to do |format|
      format.html
      format.json { render json: @allele.to_hsh }
    end
  end

  # GET /alleles/new
  def new
    @allele = Allele.new
  end

  # GET /alleles/1/edit
  def edit; end

  # POST /alleles
  def create
    @allele = Allele.new(allele_params)

    respond_to do |format|
      if @allele.save
        format.html { redirect_to @allele }
        format.json { render json: @allele.to_hsh, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @allele.errors }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alleles/1
  def update
    respond_to do |format|
      if @allele.update(allele_params)
        format.html { redirect_to @allele }
        format.json { render json: @allele.to_hsh, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @allele.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alleles/1
  def destroy
    @allele.destroy!

    respond_to do |format|
      format.html { redirect_to alleles_url }
      format.json { head :no_content }
    end
  end

  private

  def set_allele
    @allele = Allele.find(params[:id])
  end

  def allele_params
    params.require(:allele).permit(:name, :chromosome_id, :inheritable_id, :inheritable_type)
  end
end
