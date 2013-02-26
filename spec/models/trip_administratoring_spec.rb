require 'spec_helper'

describe TripAdministratoring do
	let(:user) { FactoryGirl.create(:user) }
	let(:trip) { FactoryGirl.create(:trip) }
	let(:admin) { trip.trip_administratorings.create(user: user) }

	subject { admin }

	it { should be_valid }

	it { should respond_to(:trip) }
	it { should respond_to(:user) }
end
