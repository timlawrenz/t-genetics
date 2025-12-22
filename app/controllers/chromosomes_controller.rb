# frozen_string_literal: true

class ChromosomesController < ApplicationController
  def index
    chromosomes = Chromosome.all
    fresh_when(chromosomes)
    render json: chromosomes.map(&:to_hsh)
  end

  def show
    chromosome = Chromosome.find(params[:id])
    fresh_when(chromosome)
    render json: chromosome.to_hsh
  end
end
