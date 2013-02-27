require 'spec_helper'

describe User do

		let(:user) { User.new(username: "foobar",
				email: "user@example.com", password: "foobar",
				password_confirmation: "foobar") }

	subject { user }

	it { should respond_to(:username) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:tagline) }
	it { should respond_to(:site_admin) }
	it { should respond_to(:trip_adminships) }
	it { should respond_to(:administrated_trips) }
	it { should respond_to(:trip_whitelistings) }
	it { should respond_to(:whitelisted_trips) }
	it { should respond_to(:trip_subscriptions) }
	it { should respond_to(:subscribed_trips) }

	it { should respond_to(:trips) }
	it { should respond_to(:events) }

	it { should be_valid }

	context "when the username is blank" do
		before { user.username = " " }
		it { should_not be_valid }
	end

	context "when the email is blank" do
		before { user.email = " " }
		it { should_not be_valid }
	end

	context "when password is blank" do
		before { user.password = " " }
		it { should_not be_valid }
	end

	context "when password_confirmation is blank" do
		before { user.password_confirmation = " " }
		it { should_not be_valid }
	end

	context "when password_confirmation doesn't match password" do
		before { user.password_confirmation = "barfoo" }
		it { should_not be_valid }
	end

	context "when username is too long" do
		before { user.username = "a"*25 }
		it { should_not be_valid }
	end

	context "when password is too long" do
		before do
			user.password = "a"*17
			user.password_confirmation = user.password
		end

		it { should_not be_valid }
	end

	context "when password is too short" do
		before do
			user.password = "a"*5
			user.password_confirmation = user.password
		end
		it { should_not be_valid }
	end

	describe "when invalid email format" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
    	addresses.each do |invalid_email|
    		user.email = invalid_email
    		user.should_not be_valid
    	end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end
    end
  end

	describe "when email is already taken" do
		before do
			second_user = FactoryGirl.build(:user)
			second_user.email = "user@example.com"
			second_user.save
		end
		it { should_not be_valid }
	end

	describe "return value of #authenticate" do
		before { user.save }
		let(:found_user) { User.find_by_email(user.email)}

		context "with valid password" do
			it { should == found_user.authenticate(user.password) }
		end

		context "with invalid password" do
			it { should_not == found_user.authenticate("invalid") }
		end
	end

	context "with capitalized email" do
		it "should save downcased" do
			new_email = "USER@example.com"
			user.email = new_email
			user.save
			user.reload.email.should == new_email.downcase
		end
	end

	describe "after successful save" do
		before do
			user.save
		end
	end
end
