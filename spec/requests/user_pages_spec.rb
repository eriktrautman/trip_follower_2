require 'spec_helper'

describe "UserPages" do

	subject { page }

	# ----------------------------------------------------------------------------
	describe "#index" do

		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			visit users_path
			5.times { FactoryGirl.create(:user) }
		end

		it { source.should have_selector( 'title', text: "Users" ) }
		it { should have_selector( 'h1', text: "users" ) }

		it "should list every user" do
			User.all.each do |user|
				page.should have_selector('a', href: user_path(user) )
			end
		end

	end

	# ----------------------------------------------------------------------------
	describe "#show" do

		let(:user) { FactoryGirl.create(:user) }
		let(:trip1) { FactoryGirl.create(:trip, creator: user, name: "Lorem Ipsum") }
		let(:trip2) { FactoryGirl.create(:trip, creator: user, name: "Dolor Sit Amet") }

		before(:each) do
			# forcing creation of trips
			trip1
			trip2

			sign_in(user)
			visit user_path(user)
		end

		it { source.should have_selector( 'title', text: user.username ) }
		it { should have_selector( 'h1', text: user.username ) }
		it { should have_link( trip1.name, href: trip_path(trip1) ) }
		it { should have_link( trip2.name, href: trip_path(trip2) ) }

	end

	# ----------------------------------------------------------------------------
	describe "#new" do

		before(:each) do
			visit new_user_path
		end

		it { should have_selector( 'title', text: "Sign Up" ) }
		it { should have_selector( 'h1', text: "Sign Up" ) }

		describe "with valid information" do
			before(:each) do
				fill_in("user_username", with: "example")
				fill_in("user_email", with: "user@example.com")
				fill_in("user_password", with: "foobar")
				fill_in("user_password_confirmation", with: "foobar")
			end

			it "should create the user" do
				expect{ click_button("commit") }.to change(User, :count).by(1)

			end

			describe "after saving the user" do
				before(:each) do
					click_button("commit")
				end
				let(:user) { User.find_by_email( "user@example.com" ) }

				it "should redirect to user's show page" do
					current_path.should == user_path(user)
				end

				it { should have_selector('h1', text: user.username ) }
				it { should have_selector('div.alert.alert-success') }
				it { should have_link('Sign Out') }
				it { should_not have_selector('h1', text: "Sign In") }

			end

		end

		describe "with invalid information" do
			before(:each) do
				click_button("commit")
			end

			it "should not add the user" do
				expect{ click_button("commit") }.not_to change(User, :count)
			end

			it { should have_selector('div.alert.alert-error') }

		end

	end

  # ----------------------------------------------------------------------------
	describe "#edit" do

		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in(user)
			visit edit_user_path(user)
			fill_in("user_password", with: "foobar")
			fill_in("user_password_confirmation", with: "foobar")
		end

		it { should have_selector( 'title', text: "Edit" ) }
		it { should have_selector( 'h1', text: "Edit" ) }
		it { should have_selector( 'nav' ) } # MOVE THIS LATER

		context "form" do

			it "should update the user" do
				fill_in("user_username", with: "baz")
				click_button("commit")
				user.reload.username.should eq("baz")
			end

			it "should not create a new user" do
				expect{ click_button("commit") }.not_to change(User, :count)
			end

			describe "after saving the user" do
				before(:each) do
					click_button("commit")
				end

				it "should redirect to user's show page" do
					current_path.should == user_path(user)
				end

				it { should have_selector('h1', text: user.username ) }
				it { should have_selector('div.alert.alert-success') }
				it { should have_link('Sign Out', href: signout_path) }

			end


			describe "with invalid information" do
				before(:each) do
					fill_in("user_email", with: "x")
				end

				it "should not add the user" do
					expect{ click_button("commit") }.not_to change(User, :count)
				end

				it "should display an error" do
					click_button("commit")
					subject.should have_selector('div.alert.alert-error')
				end

			end

		end

	end


end
