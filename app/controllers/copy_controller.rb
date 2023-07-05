class CopyController < ApplicationController
  def index
    copy_data = get_copy_data
    since = params[:since]

    if since.nil?
      render_copy_data(copy_data)
    else
      filtered_copy_data = filter_copy_data(copy_data, since)
      if filtered_copy_data.empty?
        render json: { message: "We don't have records after the specified time" }
      else
        render_copy_data(filtered_copy_data)
      end
    end
  end

  def show
    key = params[:key]
    copy_data = get_copy_data

    if copy_data.any? { |record| record['fields']['Key'] == key }
      record = copy_data.find { |r| r['fields']['Key'] == key }
      render json: record['fields']['Copy']
    else
      render_not_found
    end
  end

  def refresh
    airtable_records = fetch_airtable_data
    copy_data = transform_airtable_data(airtable_records)
    update_copy_data(copy_data)
    render_copy_data(copy_data)
  end

  private

  def filter_copy_data(copy_data, since)
    copy_data.select { |record| record['createdTime'] > since }
  end

  def get_copy_data
    if File.exist?(FILE_PATH)
      json_data = File.read(FILE_PATH)
      JSON.parse(json_data)
    else
      []
    end
  end

  def render_copy_data(copy_data)
    if copy_data.empty?
      render_not_found
    else
      render json: copy_data
    end
  end

  def render_not_found
    render json: { error: 'Key not found' }, status: :not_found
  end

  def fetch_airtable_data
    url = "https://api.airtable.com/v0/#{AIRTABLE_BASE_ID}/#{AIRTABLE_TABLE_NAME}"
    headers = { 'Authorization' => "Bearer #{AIRTABLE_API_KEY}" }

    response = HTTParty.get(url, headers: headers)

    if response.code == 200
      JSON.parse(response.body)['records']
    else
      []
    end
  end

  def transform_airtable_data(airtable_records)
    airtable_records.map do |record|
      {
        'id' => record['id'],
        'createdTime' => record['createdTime'],
        'fields' => record['fields']
      }
    end
  end

  def update_copy_data(copy_data)
    File.open(FILE_PATH, 'w') do |file|
      file.write(JSON.pretty_generate(copy_data))
    end
  end
end
