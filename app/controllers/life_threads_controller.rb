class LifeThreadsController < ApplicationController
  before_filter :signed_in_user, except: [:show]
  before_filter :correct_user, only: [:edit, :destroy, :update]

  def new
    @life_thread = LifeThread.new
  end

  def create
    @life_thread = current_user.life_threads.new(params[:life_thread])
    if @life_thread.save
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

  def edit
    @life_thread = LifeThread.find(params[:id])
  end

  def update
    @life_thread = LifeThread.find(params[:id])
    if @life_thread.update_attributes(params[:life_thread])
      flash[:success] = "Successfully updated"
      redirect_to @life_thread
    else
      flash[:error] = @life_thread.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    life_thread = LifeThread.find(params[:id])
    if life_thread.delete
      flash[:success] = "The thread was successfully deleted"
      redirect_to current_user
    else
      flash[:error] = "The thread could not be deleted"
      redirect_to life_thread
    end
  end

  private

    def correct_user
      life_thread = current_user.life_threads.find_by_id(params[:id])
      if life_thread.nil?
        flash[:error] = "Permission Denied"
        redirect_to root_path
      end
    end

end
