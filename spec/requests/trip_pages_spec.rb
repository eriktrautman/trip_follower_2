require 'spec_helper'

describe "TripPages" do

  subject { page }

  context "when user is not signed in" do

    before { visit new_trip_path }

    it "should redirect to the signin page" do
      current_path.should == signin_path
    end

  end

  # ----------------------------------------------------------------------------
  describe "#new" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in(user)
      visit new_trip_path
    end

    it { should have_selector( 'title', text: "Create" ) }
    it { should have_selector( 'h1', text: "Create" ) }

    describe "with valid information" do
      before(:each) do
        fill_in("trip_name", with: "example trip")
        fill_in("trip_hashtag", with: "tag1")
      end

      it "should create the trip" do
        expect{ click_button("commit") }.to change(Trip, :count).by(1)
      end

      describe "after saving the trip" do
        before(:each) do
          click_button("commit")
        end

        it "should redirect to user's show page" do
          current_path.should == user_path(user)
        end

        it { should have_selector('h1', text: user.username ) }
        it { should have_selector('div.alert.alert-success') }

      end

    end

    describe "with invalid information" do
      before(:each) do
        click_button("commit")
      end

      it "should not add the trip" do
        expect{ click_button("commit") }.not_to change(Trip, :count)
      end

      it { should have_selector('div.alert.alert-error') }

    end
  end

  # ----------------------------------------------------------------------------
  describe "#edit" do

    let(:user) { FactoryGirl.create(:user) }
    let(:trip) { FactoryGirl.create(:trip, creator: user) }

    context "when user is signed in" do

      before do
        sign_in(user)
      end

      context "when editing his own trip" do

        before { visit edit_trip_path(trip) }
      
        it { should have_selector('title', text: 'Trip Settings') }
        it { should have_selector('h1', text: 'Trip Settings') }
        it { should have_selector('h2', text: 'Advanced Options:')}
        it { should have_selector('#trip_whitelist_posters_true')}
        it { should_not have_selector('li', text: 'AdminUser1') }
        it { trip.reload.whitelist_posters.should == false }
        it { should have_selector('li', text: user.username) }

        context "in trip creator advanced options" do

          specify "should be able to change protected settings" do

            find(:css, '#trip_whitelist_posters_true').set(true)
            click_button("commit")
            trip.reload.whitelist_posters.should == true
          end

          context "after creating an admin user" do
            before do

            end

            xit { should have_selector('li', text: 'AdminUser1') }
          end

        end

        context "in admin options" do

          "only admin should be able to change protected settings"

          "should be able to EDIT ANOTHER USER'S TRIP!"

        end

        context "with valid changes to form" do

          before do
            fill_in(:name, with: "test")
          end

          it "should reflect those changes upon submission" do

            click_button("commit")
            trip.reload.name.should == "test"

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

      context "when editing another user's trip" do

        let(:other_user) { FactoryGirl.create(:user) }

        context "when he is not an admin for that trip" do

          before do
            sign_in(other_user)
            visit edit_trip_path(trip)
          end

          it "should redirect to root with errors" do
            current_path.should == root_path
            page.should have_selector('div.alert.alert-error')
          end
        end

        context "when he is an admin for that trip" do
          
          before do
            sign_in(other_user)
            TripAdmin.create(user: other_user, trip: trip)
            visit edit_trip_path(trip)
          end

          it "should take user to the trip's edit page as normal" do
            current_path.should == edit_trip_path(trip)
            page.should have_selector('h1', text: 'Trip Settings')
          end

          it { should_not have_link('delete', href: trip_path(trip), 
                                        method: :delete)}
          it { should_not have_selector('#trip_whitelist_posters_true')}
        end
      end
    end

    context "when user is not signed in" do

      before do
        visit edit_trip_path(trip)
      end

      it "should redirect back to root" do
        current_path.should == signin_path
      end
    end
  end

  # ----------------------------------------------------------------------------
  describe "#show" do

    let(:user) { FactoryGirl.create(:user) }
    let(:trip) { FactoryGirl.create(:trip, creator: user) }

    context "user's own trip" do

      before do
        visit trip_path(trip)
      end

      it { should have_selector('title', text: trip.name) }
      it { should have_selector('h1', text: trip.name ) }

      context "when user is signed in" do
        
        before do
          sign_in user
          visit trip_path(trip)
        end

        it { should have_link('Delete', href: trip_path(trip), 
                                        method: :delete) }
        it { should have_link('Edit', href: edit_trip_path(trip))}
      
      end

      context "when user is not signed in" do

        it { should_not have_link('delete', href: trip_path(trip),
                                            method: :delete) }

      end
    end

    context "a trip where user has no admin privileges" do

      let(:random_user) { FactoryGirl.create(:user) }

      before do
        sign_in random_user
        visit trip_path(trip)
      end

      it { should_not have_link('Edit', href: edit_trip_path(trip)) }

    end

    context "a trip where user DOES have admin privileges" do

      let(:admin_user) { FactoryGirl.create(:user) }

      before do
        TripAdmin.create(user: admin_user, trip: trip)
        sign_in admin_user
        visit trip_path(trip)
      end

      it { should have_link('Edit', href: edit_trip_path(trip) ) }

    end
  end
end



















