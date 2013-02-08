require 'spec_helper'

describe "Authentication" do
  
	subject { page }

	describe "signin page" do

		before(:each) do 
			visit signin_path
		end

		it { should have_selector('title', text: 'Sign In' ) }
		it { should have_selector('label.email') }
		it { should have_selector('label.password') }

		describe "with invalid information" do

			before do
				click_button("commit")
			end

			it "should return to the page" do
				current_path.should == sessions_path
			end

			it "should display errors" do 
				page.should have_selector('div.alert.alert-error')
			end

		end

		describe "submitting valid information" do

			let(:user) { FactoryGirl.create(:user) }

			before do
				fill_in("session_email", with: user.email)
				fill_in("session_password", with: user.password)
				click_button("commit")
			end

			it "should display a success flash" do
				page.should have_selector('div.alert.alert-success')
			end

		end
	end


	describe "authorization" do

		context "when user isn't signed in" do

			describe "when visiting a non-protected (index) page" do

				before do
					visit users_path
				end

				it { should have_link('Sign In', href: signin_path) }	
				it { should_not have_link('Sign Out', href: signout_path) }

			end

		end

		context "when user is signed in" do

			let(:user) { FactoryGirl.create(:user) }

			before { sign_in(user) }

			context "when visiting a non-protected (index) page" do

				before do
					visit users_path
				end

				it { should have_link('Sign Out', href: signout_path) }
				it { should_not have_link('Sign In', href: signin_path) }

			end
		end
	end

	it "needs to test for smart redirects"
	it "needs to test for user authorization to view profile pages"
	it "redirect after signin to my home page if not a smart redirect"
end
