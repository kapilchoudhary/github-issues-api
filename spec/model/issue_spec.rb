require 'rails_helper'

RSpec.describe Issue, type: :model do
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:title) }
  describe ".users" do
    it "includes issues with title flag" do
      user = User.create(email: 'test@example.com', password: '123456')
      issue = Issue.create!(title: "Sample issue", user: user)
      
      expect(Issue.all).to include(issue)
    end
  end
end
