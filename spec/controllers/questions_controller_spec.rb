require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to Question.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end
end