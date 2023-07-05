class CopyController < ApplicationController
  FILE_PATH = Rails.root.join('copy.json')

  def index
    render_copy_data(get_copy_data)
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

  private

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
end
