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
		it { should have_link('Create', href: new_user_path) }

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

		let(:user) { FactoryGirl.create(:user) }

		context "when user isn't signed in" do

			describe "when visiting a non-protected (index) page" do

				before do
					visit users_path
				end

				it { should have_link('Sign In', href: signin_path) }	
				it { should_not have_link('Sign Out', href: signout_path) }

			end

			describe "when visiting another user's protected edit page" do

				let(:other_user) { FactoryGirl.create(:user) }

				before { visit edit_user_path(other_user) }

				it "should redirect back to root" do
					current_path == root_path
				end
			end

			describe "when visiting the user's (protected) edit page" do

				before do
					visit edit_user_path(user)
				end

				it "should be prompted to signin" do
					current_path.should == signin_path
				end

				describe "after signing in" do

					before { sign_in(user) }

					it "should be redirected to original page" do
						current_path.should == edit_user_path(user)
					end

				end

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
				it { should have_link('New Trip', href: new_life_thread_path) }

			end

			describe "after signing out" do

				before do
					visit new_life_thread_path
					click_link "Sign Out"
				end

				xspecify "the session[:return_to] should be cleared" do
					session[:return_to].should be_nil
				end
			end

		end
	end
end
