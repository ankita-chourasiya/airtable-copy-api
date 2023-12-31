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

  describe 'GET #show' do
    context 'when a valid key is provided' do
      let(:key) { 'greeting' }

      it 'returns the copy data with the matching key in JSON format' do
        get :show, params: { key: key }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Hello, {name}!')
      end
    end

    context 'when an invalid key is provided' do
      let(:key) { 'invalid_key' }

      it 'returns a "Key not found" error message in JSON format' do
        get :show, params: { key: key }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to include('application/json')
        expect(response.body).to eq('{"error":"Key not found"}')
      end
    end
  end

  describe 'Get #refresh' do
    let(:airtable_records) do
      [
        {
          'id' => 'record1',
          'createdTime' => '2023-07-05T10:30:00Z',
          'fields' => { 'Key' => 'greeting', 'Copy' => 'Hello, {name}!' }
        },
        {
          'id' => 'record2',
          'createdTime' => '2023-07-05T11:00:00Z',
          'fields' => { 'Key' => 'bye', 'Copy' => 'Goodbye' }
        }
      ]
    end

    before do
      allow(controller).to receive(:fetch_airtable_data).and_return(airtable_records)
      allow(controller).to receive(:update_copy_data)
    end

    it 'fetches data from Airtable, updates the copy data, and renders the updated copy data' do
      expect(controller).to receive(:fetch_airtable_data).and_return(airtable_records)
      expect(controller).to receive(:update_copy_data).with(airtable_records)

      get :refresh

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      expected_copy_data = [
        { 'id' => 'record1', 'createdTime' => '2023-07-05T10:30:00Z', 'fields' => { 'Key' => 'greeting', 'Copy' => 'Hello, {name}!' } },
        { 'id' => 'record2', 'createdTime' => '2023-07-05T11:00:00Z', 'fields' => { 'Key' => 'bye', 'Copy' => 'Goodbye' } }
      ]
      expect(JSON.parse(response.body)).to eq(expected_copy_data)
    end
  end
end
