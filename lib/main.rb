require 'aws-sdk-s3vectors'

class S3VectorsBrowser
  def initialize(region: 'us-east-1')
    @client = Aws::S3Vectors::Client.new(region: region)
  end

  def list_all_resources(max_results: 10)
    list_buckets(max_results).each do |bucket|
      print_bucket_info(bucket)
      list_indexes(bucket.vector_bucket_name, max_results).each do |index|
        print_index_info(index, bucket.vector_bucket_name, max_results)
      end
    end
  end

  private

  def list_buckets(max_results)
    @client.list_vector_buckets(max_results: max_results).vector_buckets
  end

  def list_indexes(bucket_name, max_results)
    @client.list_indexes(
      vector_bucket_name: bucket_name,
      max_results: max_results
    ).indexes
  end

  def list_vectors(bucket_name, index_name, max_results)
    @client.list_vectors(
      vector_bucket_name: bucket_name,
      index_name: index_name,
      max_results: max_results
    ).vectors
  end

  def print_bucket_info(bucket)
    puts "S3 Vector buckets #{bucket.vector_bucket_name}"
  end

  def print_index_info(index, bucket_name, max_results)
    puts "  Index: #{index.index_name}"
    list_vectors(bucket_name, index.index_name, max_results).each do |vector|
      puts "    Vector: #{vector.vector_name}"
    end
  end
end

browser = S3VectorsBrowser.new
browser.list_all_resources
