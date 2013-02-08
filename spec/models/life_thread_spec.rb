require 'spec_helper'

describe LifeThread do

  subject(:thread) { LifeThread.new }

  it { should respond_to(:name) }
  it { should respond_to(:tagline) }
  it { should respond_to(:user_id) }
  it { should respond_to(:s_date) }
  it { should respond_to(:e_date) }
  it { should respond_to(:hashtag) }

end
