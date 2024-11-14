# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:skill) { create(:skill) }
  let!(:task) { create(:task, skills: [skill]) }

  describe 'GET #index' do
    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all tasks' do
      expect(json_response['data'].size).to eq(1)
    end

    it 'includes task attributes' do # RSpec/MultipleExpectations
      first_task = json_response['data'].first['attributes']
      expect(first_task['title']).to eq(task.title)
      expect(first_task['estimated_hours']).to be_a(Float)
      expect(first_task['due_date']).to eq(task.due_date.to_s)
      expect(first_task['priority_score']).to be_a(Float)
      expect(first_task['status']).to eq('pending')
      expect(first_task['skill_names']).to be_an(Array)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: task.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the requested task' do
      expect(json_response['data']['id'].to_s).to eq(task.id.to_s)
    end

    it 'includes relationships' do
      expect(json_response['data']['relationships']).to have_key('skills')
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        task: {
          title: 'New Task',
          estimated_hours: 8,
          due_date: 1.week.from_now.to_date,
          skill_ids: [skill.id]
        }
      }
    end

    context 'with valid params' do
      it 'creates a new task' do
        expect do
          post :create, params: valid_attributes
        end.to change(Task, :count).by(1)
      end

      it 'returns http created' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it 'returns the created task' do
        post :create, params: valid_attributes
        expect(json_response['data']['attributes']['title']).to eq('New Task')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        { task: { title: '' } }
      end

      it 'returns http unprocessable entity' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_attributes
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'GET #overdue' do
    let!(:overdue_task) { create(:task, :overdue, skills: [skill]) }

    before { get :overdue }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns only overdue tasks' do
      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'].first['id'].to_s).to eq(overdue_task.id.to_s)
    end
  end
end
