Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV["ELASTICSEARCH_HOST"] || "http://elasticsearch:9200",
  log: true
)
