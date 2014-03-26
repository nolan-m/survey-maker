require 'spec_helper'

describe Survey do

  it {should have_and_belong_to_many :takers}
  it { should have_many :answers }
  it { should have_many :questions }

end

