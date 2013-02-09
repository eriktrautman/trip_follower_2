require 'spec_helper'

describe "LifeThreadPages" do

  subject { page }

  context "when user is not signed in" do

    before { visit new_life_thread_path }

    it "should redirect to the signin page" do
      current_path.should == signin_path
    end

  end

  # ----------------------------------------------------------------------------
  describe "#new" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in(user)
      visit new_life_thread_path
    end

    it { should have_selector( 'title', text: "Create" ) }
    it { should have_selector( 'h1', text: "Create" ) }

    describe "with valid information" do
      before(:each) do
        fill_in("life_thread_name", with: "example thread")
      end

      it "should create the thread" do
        expect{ click_button("commit") }.to change(LifeThread, :count).by(1)
      end

      describe "after saving the thread" do
        before(:each) do
          click_button("commit")
        end

        it "should redirect to user's show page" do
          current_path.should == user_path(user)
        end

        it { should have_selector('h1', text: user.fname ) }
        it { should have_selector('div.alert.alert-success') }

      end

    end

    describe "with invalid information" do
      before(:each) do
        click_button("commit")
      end

      it "should not add the thread" do
        expect{ click_button("commit") }.not_to change(LifeThread, :count)
      end

      it { should have_selector('div.alert.alert-error') }

    end
  end

  # ----------------------------------------------------------------------------
  describe "#edit" do
  end

  # ----------------------------------------------------------------------------
  describe "#show" do

    let(:user) { FactoryGirl.create(:user) }
    let(:life_thread) { FactoryGirl.create(:life_thread, creator: user) }
    before do
      visit life_thread_path(life_thread)
    end

    it { should have_selector('title', text: life_thread.name) }
    it { should have_selector('h1', text: life_thread.name ) }


  end

end
