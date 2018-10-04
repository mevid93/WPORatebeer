class StylesController < ApplicationController
  before_action :set_style, only: [:show, :edit, :update, :destroy]

  def index
    @styles = Style.all
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end
end
