require 'rails_helper'

RSpec.describe CopyController, type: :controller do
  let(:copy_data) do
    [
      {
        'id' => 'rec1',
        'createdTime' => '2023-07-05T10:00:00.000Z',
        'fields' => {
          'Key' => 'intro',
          'Copy' => 'Welcome to our app!'
        }
      },
      {
        'id' => 'rec2',
        'createdTime' => '2023-07-05T11:00:00.000Z',
        'fields' => {
          'Key' => 'greeting',
          'Copy' => 'Hello, {name}!'
        }
      }
    ]
  end

  before do
    allow(controller).to receive(:get_copy_data).and_return(copy_data)
  end

  describe 'GET #index' do
    context 'when no "since" param is provided' do
      it 'returns all copy data in JSON format' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to eq(copy_data)
      end
    end

    context 'when a valid "since" param is provided' do
      let(:filtered_copy_data) do
        [
          {
            'id' => 'rec2',
            'createdTime' => '2023-07-05T11:00:00.000Z',
            'fields' => {
              'Key' => 'greeting',
              'Copy' => 'Hello, {name}!'
            }
          }
        ]
      end

      it 'returns the filtered copy data in JSON format' do
        since_time = '2023-07-05T10:30:00.000Z'
        expected_message = "We don't have records after the specified time"

        get :index, params: { since: since_time }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to eq(filtered_copy_data)
      end

      it 'returns an error message if no records match the "since" param' do
        since_time = '2023-07-05T12:00:00.000Z'
        expected_message = "We don't have records after the specified time"

        get :index, params: { since: since_time }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to eq({ 'message' => expected_message })
      end
    end
  end
end
