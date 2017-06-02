# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LessonsController, type: :controller do
  before do
    @lesson = FactoryGirl.create(:lesson)
  end
  context 'regular user can see' do
    before do
      sign_in volunteer
    end
    it 'get index' do
      get :index
      expect(response.status).to eq 200
    end

    it 'get new' do
      get :new
      expect(response.status).to eq 200
    end

    it 'show lesson' do
      get :show, params: { id: @lesson.id }
      expect(response.status).to eq 200
    end
  end

  context 'admin user can see' do
    before do
      sign_in admin
    end
    it 'create lesson' do
      expect do
        post :create, params: { lesson: FactoryGirl.attributes_for(:lesson) }
      end.to change { Lesson.count }.by(1)
    end

    it 'creates lesson and redirects' do
      post :create,
           params: { lesson: FactoryGirl.attributes_for(:lesson) }

      expect(response).to redirect_to(admin_lesson_url(Lesson.last))
    end

    it 'get edit' do
      get :edit, params: { id: @lesson.id }
      expect(response.status).to eq 200
    end

    it 'update lesson' do
      attrs = FactoryGirl.attributes_for(:lesson)
      attrs[:links] = attrs[:links].join("\n")
      patch :update, params: { id: @lesson.id, lesson: attrs }
      expect(response).to redirect_to(admin_lesson_url(@lesson))
    end

    it 'destroy lesson' do
      expect do
        delete :destroy, params: { id: @lesson.id }
      end.to change { Lesson.count }.by(-1)

      expect(response).to redirect_to(admin_lessons_url)
    end

    it 'destroy lesson and redirect' do
      delete :destroy, params: { id: @lesson.id }
      expect(response).to redirect_to(admin_lessons_url)
    end
  end
end
