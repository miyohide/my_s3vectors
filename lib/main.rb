require 'aws-sdk-s3vectors'

client = Aws::S3Vectors::Client.new(region: 'us-east-1')

resp = client.list_vector_buckets({max_results: 10})

# respに格納されているS3 VectorsバケットにあるIndexを出力する
resp.vector_buckets.each do |bucket|
  vector_bucket_name = bucket.vector_bucket_name
  puts "S3 Vector buckets #{vector_bucket_name}"

  indexes = client.list_indexes({
    vector_bucket_name: vector_bucket_name,
    max_results: 10
  })

  indexes.indexes.each do |i|
    puts "  Index: #{i.index_name}"
  end
end
