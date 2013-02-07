require 'spec_helper'

describe User do

		let(:user) { User.new(fname: "Example", lname: "User", 
				email: "user@example.com", password: "foobar", 
				password_confirmation: "foobar") }

	subject { user }

	it { should respond_to(:fname) }
	it { should respond_to(:lname) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }

	it { should be_valid }

	context "when the firstname is blank" do
		before { user.fname = " " }
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

	context "when first name is too long" do
		before { user.fname = "a"*25 }
		it { should_not be_valid }
	end

	context "when first name is too short" do
		before { user.fname = "a" }
		it { should_not be_valid }
	end

	context "when last name is too long" do
		before { user.lname = "a"*25 }
		it { should_not be_valid }
	end

	context "when last name is too short" do
		before { user.lname = "a" }
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

end
