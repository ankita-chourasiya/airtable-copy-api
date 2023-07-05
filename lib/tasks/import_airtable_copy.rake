require 'httparty'
require 'dotenv/load'

namespace :import do
  desc 'Import Copy base from Airtable and save to local JSON file'
  task copy: :environment do

    api_key = ENV['AIRTABLE_API_KEY']
    base_id = ENV['AIRTABLE_BASE_ID']
    table_name = ENV['AIRTABLE_TABLE_NAME']

    url = "https://api.airtable.com/v0/#{base_id}/#{table_name}"

    response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{api_key}" })

    if response.code == 200
      data = JSON.parse(response.body)

      records = data['records']

      records.each do |record|
        puts "Field Value: #{record}"
      end
    else
      puts "Error: #{response.code} - #{response.message}"
    end
  end
end
