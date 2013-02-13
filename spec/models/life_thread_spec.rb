require 'spec_helper'

describe LifeThread do

  let(:user) { FactoryGirl.create(:user) }
  subject(:thread) { user.life_threads.new( name: "Example Thread",
                                            hashtag: "tag1" ) }

  it { should respond_to(:name) }
  it { should respond_to(:tagline) }
  it { should respond_to(:description) }
  it { should respond_to(:s_date) }
  it { should respond_to(:e_date) }
  it { should respond_to(:hashtag) }

  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:events) }

  it { should be_valid }  

  describe "accessible attributes" do
    it "should not allow access to creator_id" do
      expect do
        LifeThread.new(creator_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "validations" do

    context "when name is not present" do
      before { thread.name = "     " }
      it { should_not be_valid }
    end

    context "when name is too long" do
      before { thread.name = "a"*25 }
      it { should_not be_valid }
    end

    context "when name is too short" do
      before { thread.name = "a"*3 }
      it { should_not be_valid }
    end

    context "when hashtag is too long" do
      before { thread.hashtag = "a"*65 }
      it { should_not be_valid }
    end

    context "when hashtag is too short" do
      before { thread.hashtag = "" }
      it { should_not be_valid }
    end

    context "when tagline is too long" do
      before { thread.tagline = "a"*141 }
      it { should_not be_valid }
    end

    context "when description is too long" do
      before { thread.description = "a"*1001 }
      it { should_not be_valid }
    end

    context "when end date is before start date" do
      before do
        thread.s_date = Date.new(2013,1,1)
        thread.e_date = Date.new(2012,12,12)
      end
      it { should_not be_valid }
    end

    context "when end date is same as start date" do
      before do
        thread.s_date = Date.new(2013,1,1)
        thread.e_date = Date.new(2013,1,1)
      end
      it { should be_valid }
    end

  end

end
