# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::Create do
  let(:skill) { create(:skill) }

  describe '.call' do
    subject(:context) { described_class.call(params: params) }

    context 'when params are valid' do
      let(:params) do
        {
          title: 'New Task',
          estimated_hours: 8,
          due_date: 1.week.from_now,
          skill_ids: [skill.id]
        }
      end

      it 'succeeds' do
        expect(context).to be_success
      end

      it 'creates a task' do
        expect { context }.to change(Task, :count).by(1)
      end

      it 'provides the task' do
        expect(context.task).to be_persisted
        expect(context.task.title).to eq('New Task')
      end

      it 'assigns skills to the task' do
        expect(context.task.skills).to include(skill)
      end

      it 'sets task attributes correctly' do
        expect(context.task).to have_attributes(
          title: 'New Task',
          estimated_hours: 8
        )
        expect(context.task.due_date.to_date).to eq(1.week.from_now.to_date)
      end
    end

    context 'when params are invalid' do
      let(:params) do
        {
          title: '',
          estimated_hours: -1,
          due_date: nil,
          skill_ids: []
        }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides error messages' do
        expect(context.error_messages).to include(/can't be blank/i)
      end

      it 'does not create a task' do
        expect { context }.not_to change(Task, :count)
      end
    end

    context 'when due date is in the past' do
      let(:params) do
        {
          title: 'Past Task',
          estimated_hours: 8,
          due_date: 1.day.ago,
          skill_ids: [skill.id]
        }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides error about past date' do
        expect(context.error_messages).to include(/due date/i)
      end
    end

    context 'when no skills are provided' do
      let(:params) do
        {
          title: 'No Skills Task',
          estimated_hours: 8,
          due_date: 1.week.from_now,
          skill_ids: []
        }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides error about required skills' do
        expect(context.error_messages).to include(/skills/i)
      end
    end

    context 'when estimated hours exceed limit' do
      let(:params) do
        {
          title: 'Long Task',
          estimated_hours: 25,
          due_date: 1.week.from_now,
          skill_ids: [skill.id]
        }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides error about hours limit' do
        expect(context.error_messages).to include(/estimated hours/i)
      end
    end
  end
end
