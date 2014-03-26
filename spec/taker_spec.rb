require 'spec_helper'

describe Taker do
  it { should have_many :responses }
  it { should have_and_belong_to_many :surveys }
  it { should have_many :answers }
  it { should have_many :questions }
end

