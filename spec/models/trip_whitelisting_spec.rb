require 'spec_helper'

describe TripWhitelisting do

	let(:user) { FactoryGirl.create(:user) }
	let(:trip) { FactoryGirl.create(:trip) }
	let(:whitelisting) { TripWhitelisting.new(user: user, trip: trip) }

	subject { whitelisting }

	it { should be_valid }

	it { should respond_to(:trip) }
	it { should respond_to(:user) }


end
