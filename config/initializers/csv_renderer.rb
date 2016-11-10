ActionController.add_renderer :csv do |csv, options|
  filename = options[:filename] || options[:template]
  data = csv.to_csv(options)
  send_data data,
            type: Mime::CSV,
            disposition: "attachment; filename=#{filename}.csv"
end
