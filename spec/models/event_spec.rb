require 'spec_helper'

describe Event do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:thread) { FactoryGirl.create(:thread, creator: user) }
  let(:event) { thread.events.build(name: "Example", creator_id: user.id,
  																	hashtag: "event1") }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:hashtag) }
  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:life_thread_id ) }
  it { should respond_to(:life_thread) }
  

end
