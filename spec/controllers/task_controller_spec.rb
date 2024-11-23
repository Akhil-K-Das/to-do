require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) } # The current user
  let(:workspace) { create(:workspace) }
  let(:category) { create(:category) }
  let!(:task) { create(:task, assignee: user, category: category, workspace: workspace) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      puts response.body # Debugging
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1) # Ensure the created task is returned
    end
  end

  describe 'POST #create' do
    it 'creates a new task' do
      post :create, params: { task: { title: 'New Task', due_date: 1.day.from_now, category_id: category.id, assignee_id: user.id, workspace_id: workspace.id } }
      puts response.body # Debugging
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('New Task')
    end
  end
end
