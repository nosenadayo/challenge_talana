# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  # Configuración base de datos de prueba
  let!(:skill) { create(:skill, name: 'Ruby') }
  let!(:employee) { create(:employee, daily_hours: 5.97) }

  # Aseguramos que el empleado tenga la habilidad
  before do
    create(:employee_skill, employee: employee, skill: skill)
  end

  describe 'GET #index' do
    before do
      # Creamos empleados adicionales con sus habilidades
      3.times do
        emp = create(:employee)
        create(:employee_skill, employee: emp, skill: skill)
      end
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all employees' do
      expect(json_response['data'].size).to eq(4)
    end

    it 'returns employees with correct format' do
      first_employee = json_response['data'].first
      expect(first_employee['attributes']).to include(
        'name' => be_a(String),
        'daily_hours' => be_a(Float),
        'skill_names' => be_an(Array)
      )
    end
  end

  describe 'GET #show' do
    context 'when employee exists' do
      before { get :show, params: { id: employee.id } }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct employee' do
        expect(json_response['data']['id'].to_i).to eq(employee.id)
      end

      it 'includes employee attributes' do
        attributes = json_response['data']['attributes']
        expect(attributes).to include(
          'name' => employee.name,
          'daily_hours' => employee.daily_hours.to_f
        )
        expect(attributes['skill_names']).to include(skill.name)
        expect(attributes['total_assignments']).to eq(0)
      end
    end

    context 'when employee does not exist' do
      before { get :show, params: { id: 999 } }

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #availability' do
    let(:availability) do
      create(:availability,
             employee: employee,
             date: Time.zone.today,
             available_hours: 8)
    end

    context 'with valid date range' do
      before do
        get :availability, params: {
          id: employee.id,
          start_date: Time.zone.today.to_s,
          end_date: 1.week.from_now.to_s
        }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #available_on_date' do
    let(:availability) do
      create(:availability,
             employee: employee,
             date: Time.zone.today,
             available_hours: 8)
    end

    context 'with valid date' do
      before do
        get :available_on_date, params: { date: Time.zone.today.to_s }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid date' do
      before { get :available_on_date, params: { date: 'invalid' } }

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
