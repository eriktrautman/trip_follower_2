require 'spec_helper'

describe "EventPages" do

  subject { page }

  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }

  context "when user is not signed in" do

  end

end