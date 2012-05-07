
desc "This task reindexes Books"
task :eod_job => :environment do
  p "BEGIN TASK - #{Time.new} Initiating complete reindex of books..."
  Book.solr_reindex(:batch_size => 1000)
  p "COMPLETED TASK #{Time.new}"
end
