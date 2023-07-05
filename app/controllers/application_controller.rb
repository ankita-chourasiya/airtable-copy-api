require 'httparty'
require 'dotenv/load'

class ApplicationController < ActionController::Base
  FILE_PATH = Rails.root.join('copy.json')
  AIRTABLE_API_KEY = ENV['AIRTABLE_API_KEY']
  AIRTABLE_BASE_ID = ENV['AIRTABLE_BASE_ID']
  AIRTABLE_TABLE_NAME = ENV['AIRTABLE_TABLE_NAME']
end
