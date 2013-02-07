require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "#show" do

		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			visit user_path(user)
		end

		it { source.should have_selector( 'title', text: user.fname ) }
		it { should have_selector( 'h1', text: user.fname ) }

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
				fill_in(:fname, with: "example")
				fill_in(:lname, with: "user")
				fill_in(:email, with: "user@example.com")
				fill_in(:password, with: "foobar")
				fill_in(:password_confirmation, with: "foobar")
			end

			it "should create the user" do
				expect{ click_button(:submit) }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before(:each) do
					click_button(:submit)
					let(:user) { User.find_by_email( "user@example.com" ) }
				end

				it "should redirect to user's show page" do
					assert_redirected_to users_path(user)
				end

				it { should have_selector('div.alert.alert-success', text: 'Welcome') }

			end



			#create user, render the flash and redirect to the show page

		end

		describe "with invalid information"
			#not create user, render the flash and stay on the new page with autofilled info

	end
  
end
