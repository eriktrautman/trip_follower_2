require 'spec_helper'

describe TripAdmin do
	let(:user) { FactoryGirl.create(:user) }
	let(:trip) { FactoryGirl.create(:trip) }
	let(:admin) { TripAdmin.new(user: user, trip: trip) }

	subject { admin }

	it { should be_valid }

	it { should respond_to(:trip) }
	it { should respond_to(:user) }
end
