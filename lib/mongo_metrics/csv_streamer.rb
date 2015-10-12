module MongoMetrics
  # Here, we add a new csv renderer
  ActionController::Renderers.add :csv do |model, options|
    headers = self.response.headers
    headers["Content-Disposition"] = %(attachment; filename="#{controller_name}.csv")
    headers["Cache-Control"] = "no-cache"
    headers.delete "Content-Length"
    self.content_type ||= Mime::CSV
    self.response_body = CSVStreamer.new(model)  # Here, we set the response body equal to a custom object that streams
  end

  class CSVStreamer
    def initialize(scope)
      @scope = scope
    end

    def each
      @scope.each do |record|  # Yields one record at a time from the db
        yield record.to_csv
      end
    end
  end
end