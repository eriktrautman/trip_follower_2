require 'spec_helper'

describe User do

	before do
		@user = User.new(fname: "Example", lname: "User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")	
	end

	subject { User.new }

	it { should respond_to(:fname) }
	it { should respond_to(:lname) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }


end
