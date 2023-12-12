# frozen_string_literal: true

class ChromosomesController < ApplicationController
  before_action :set_chromosome, only: %i[show edit update destroy]

  # GET /chromosomes
  def index
    @chromosomes = Chromosome.all
  end

  # GET /chromosomes/1
  def show; end

  # GET /chromosomes/new
  def new
    @chromosome = Chromosome.new
  end

  # GET /chromosomes/1/edit
  def edit; end

  # POST /chromosomes
  def create
    @chromosome = Chromosome.new(chromosome_params)

    if @chromosome.save
      redirect_to @chromosome, notice: 'Chromosome was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chromosomes/1
  def update
    if @chromosome.update(chromosome_params)
      redirect_to @chromosome, notice: 'Chromosome was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /chromosomes/1
  def destroy
    @chromosome.destroy!
    redirect_to chromosomes_url, notice: 'Chromosome was successfully destroyed.',
                                 status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chromosome
    @chromosome = Chromosome.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chromosome_params
    params.require(:chromosome).permit(:name)
  end
end
