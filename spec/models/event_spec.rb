require 'spec_helper'

describe Event do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:trip) { FactoryGirl.create(:trip, creator: user) }
  subject(:event) { trip.events.build(	name: "Example", 
  																						creator_id: user.id,
  																						hashtag: "event1", 
  																						date: Date.new(2012,1,1)
  																						) }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:hashtag) }
  it { should respond_to(:tagline) }
  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:trip_id ) }
  it { should respond_to(:trip) }

  it { should be_valid }

  context "validations" do
    context "when name is not present" do
      before { event.name = " " }
      it { should_not be_valid }
    end

    context "when name is too long" do
      before { event.name = "a"*25 }
      it { should_not be_valid }
    end

    context "when hashtag is too long" do
      before { event.hashtag = "a"*65 }
      it { should_not be_valid }
    end

    context "when hashtag is too short" do
      before { event.hashtag = "" }
      it { should_not be_valid }
    end

    context "when tagline is too long" do
      before { event.tagline = "a"*141 }
      it { should_not be_valid }
    end
  end
end
