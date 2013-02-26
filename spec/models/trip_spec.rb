require 'spec_helper'

describe Trip do

  let(:user) { FactoryGirl.create(:user) }
  subject(:trip) { user.trips.new( name: "Example trip",
                                            hashtag: "tag1" ) }

  it { should respond_to(:name) }
  it { should respond_to(:tagline) }
  it { should respond_to(:description) }
  it { should respond_to(:s_date) }
  it { should respond_to(:e_date) }
  it { should respond_to(:hashtag) }
  it { should respond_to(:public_view) }
  it { should respond_to(:whitelist_posters) }
  it { should respond_to(:trip_administratorings) }
  it { should respond_to(:admins) }
  it { should respond_to(:trip_whitelistings) }
  it { should respond_to(:whitelisted_users) }
  it { should respond_to(:trip_subscriptions) }
  it { should respond_to(:subscribed_users) }

  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:events) }

  it { should be_valid }  

  describe "accessible attributes" do
    it "should not allow access to creator_id" do
      expect do
        Trip.new(creator_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "validations" do

    context "when name is not present" do
      before { trip.name = "     " }
      it { should_not be_valid }
    end

    context "when name is too long" do
      before { trip.name = "a"*25 }
      it { should_not be_valid }
    end

    context "when name is too short" do
      before { trip.name = "a"*3 }
      it { should_not be_valid }
    end

    context "when hashtag is too long" do
      before { trip.hashtag = "a"*65 }
      it { should_not be_valid }
    end

    context "when hashtag is too short" do
      before { trip.hashtag = "" }
      it { should_not be_valid }
    end

    context "when tagline is too long" do
      before { trip.tagline = "a"*141 }
      it { should_not be_valid }
    end

    context "when description is too long" do
      before { trip.description = "a"*1001 }
      it { should_not be_valid }
    end

    context "when end date is before start date" do
      before do
        trip.s_date = Date.new(2013,1,1)
        trip.e_date = Date.new(2012,12,12)
      end
      it { should_not be_valid }
    end

    context "when end date is same as start date" do
      before do
        trip.s_date = Date.new(2013,1,1)
        trip.e_date = Date.new(2013,1,1)
      end
      it { should be_valid }
    end

  end

end
