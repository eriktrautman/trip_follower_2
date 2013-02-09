class LifeThreadsController < ApplicationController
  before_filter :signed_in_user, except: [:show]

  def new
    @thread = LifeThread.new
  end

  def create
    @thread = current_user.life_threads.new(params[:life_thread])
    if @thread.save
      flash[:success] = "Your trip has been created!"
      redirect_to current_user
    else
      flash[:error] = "Your trip could not be created"
      render :new
    end
  end

  def show
    @life_thread = LifeThread.find(params[:id])
  end

end
