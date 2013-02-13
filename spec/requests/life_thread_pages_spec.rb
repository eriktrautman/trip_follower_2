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

    let(:user) { FactoryGirl.create(:user) }
    let(:life_thread) { FactoryGirl.create(:life_thread, creator: user) }

    context "when user is signed in" do

      before do
        sign_in(user)
      end

      context "when editing his own thread" do

        before { visit edit_life_thread_path(life_thread) }
      
        it { should have_selector('title', text: 'Edit') }
        it { should have_selector('h1', text: 'Edit') }

        context "with valid changes to form" do

          before do
            fill_in(:name, with: "test")
          end

          it "should reflect those changes upon submission" do

            click_button("commit")
            life_thread.reload.name.should == "test"

          end
        end

        context "with invalid changes to form" do

          before { fill_in(:name, with: " ") }

          it "should not succeed" do

            click_button("commit")
            page.should have_selector('div.alert.alert-error')

          end
        end
      end

      context "when editing another user's thread" do

        let(:other_user) { FactoryGirl.create(:user) }
        before do
          sign_in(other_user)
          visit edit_life_thread_path(life_thread)
        end

        it "should redirect to root with errors" do
          current_path.should == root_path
          page.should have_selector('div.alert.alert-error')
        end
      end
    end

    context "when user is not signed in" do

      before do
        visit edit_life_thread_path(life_thread)
      end

      it "should redirect back to root" do
        current_path.should == signin_path
      end
    end
  end

  # ----------------------------------------------------------------------------
  describe "#show" do

    let(:user) { FactoryGirl.create(:user) }
    let(:life_thread) { FactoryGirl.create(:life_thread, creator: user) }

    context "user's own thread" do

      before do
        visit life_thread_path(life_thread)
      end

      it { should have_selector('title', text: life_thread.name) }
      it { should have_selector('h1', text: life_thread.name ) }

      context "when user is signed in" do
        
        before do
          sign_in user
          visit life_thread_path(life_thread)
        end

        it { should have_link('Delete', href: life_thread_path(life_thread), 
                                        method: :delete) }
        it { should have_link('Edit', href: edit_life_thread_path(life_thread))}
      
      end

      context "when user is not signed in" do

        it { should_not have_link('delete', href: life_thread_path(life_thread),
                                            method: :delete) }

      end
    end
  end
end



















