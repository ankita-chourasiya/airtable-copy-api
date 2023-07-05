namespace :load do
  desc 'Load Copy data from local JSON file'
  task copy: :environment do
    file_path = 'copy.json'

    begin
      json_data = File.read(file_path)
      records = JSON.parse(json_data)

      records.each do |record|
        puts "Loaded Record: #{JSON.pretty_generate(record)}"
      end

      puts "Data loaded from copy.json"
    rescue Errno::ENOENT
      puts "copy.json file not found"
    rescue JSON::ParserError
      puts "Error parsing JSON data in copy.json"
    end
  end
end
