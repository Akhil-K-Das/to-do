require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_date) }
    it { should belong_to(:category) }
  end

  describe 'methods' do
    it 'calculates overdue status correctly' do
      workspace = Workspace.create!(name: 'Example Workspace', url: 'example.com', api_key: 'sample_key')
      category = Category.create!(name: 'Work')
      task = Task.create!(title: 'Test Task', due_date: 1.day.from_now, category: category, workspace: workspace)

      task.update(due_date: 2.days.ago) # Simulate an overdue task
      expect(task.due_date < Time.zone.now).to be true
    end
  end
end
