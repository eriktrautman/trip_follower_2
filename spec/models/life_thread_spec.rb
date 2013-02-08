require 'spec_helper'

describe LifeThread do

  let(:user) { FactoryGirl.create(:user) }
  subject(:thread) { user.life_threads.new(name: "Example Thread") }

  it { should respond_to(:name) }
  it { should respond_to(:tagline) }
  it { should respond_to(:description) }
  it { should respond_to(:s_date) }
  it { should respond_to(:e_date) }
  it { should respond_to(:hashtag) }

  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }

  describe "accessible attributes" do
    it "should not allow access to creator_id" do
      expect do
        LifeThread.new(creator_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "validations" do

    context "when name is not present" do
      before { thread.name = " " }
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

  end

end
