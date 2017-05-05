class CanTheCansController < ApplicationController
  include CanTheCansHelper
  def input_can_type

  end

  def get_can_type
    @cans = what_can_is_it(params[:sentence])
    render json: @cans
  end
end