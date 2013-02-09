require 'spec_helper'

describe SessionsController do

  describe "#destroy" do

    before do
      session[:return_to] = new_life_thread_path
      delete :destroy
    end

    it "destroys the session[:return_to]" do
      session[:return_to].should be_nil
    end
  end
end
