require 'rails_helper'

describe GuestUser do
  subject { described_class.new }

  describe "#email" do
    it "provides a simple default email to use" do
      expect(subject.email).to eq "example@gmail.com"
    end
  end

  describe "#authenticated" do
    it "should always return false since this is a stub user" do
      expect(subject.authenticated?).to eq false
    end
  end

  describe "#nickname" do
    it "provides a simple nickname to use" do
      expect(subject.nickname).to eq "friend"
    end
  end
end
