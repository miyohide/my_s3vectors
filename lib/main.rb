require 'aws-sdk-s3vectors'

# S3 Vectorsのリソースを閲覧するためのクラス
class S3VectorsBrowser
  # クライアントを初期化する
  # @param region [String] AWSリージョン名(デフォルト: us-east-1)
  def initialize(region: 'us-east-1')
    @client = Aws::S3Vectors::Client.new(region: region)
  end

  # 全てのS3 Vectorsリソースを一覧表示する
  # @param max_results [Integer] 取得する最大結果数(デフォルト: 10)
  def list_all_resources(max_results: 10)
    list_buckets(max_results).each do |bucket|
      print_bucket_info(bucket)
      list_indexes(bucket.vector_bucket_name, max_results).each do |index|
        print_index_info(index, bucket.vector_bucket_name, max_results)
      end
    end
  end

  private

  # Vector bucketの一覧を取得する
  # @param max_results [Integer] 取得する最大結果数
  # @return [Array] Vector bucketsの配列
  def list_buckets(max_results)
    @client.list_vector_buckets(max_results: max_results).vector_buckets
  end

  # 指定されたbucketのindexの一覧を取得する
  # @param bucket_name [String] Vector bucket名
  # @param max_results [Integer] 取得する最大結果数
  # @return [Array] Indexesの配列
  def list_indexes(bucket_name, max_results)
    @client.list_indexes(
      vector_bucket_name: bucket_name,
      max_results: max_results
    ).indexes
  end

  # 指定されたbucketとindexのvectorの一覧を取得する
  # @param bucket_name [String] Vector bucket名
  # @param index_name [String] Index名
  # @param max_results [Integer] 取得する最大結果数
  # @return [Array] Vectorsの配列
  def list_vectors(bucket_name, index_name, max_results)
    @client.list_vectors(
      vector_bucket_name: bucket_name,
      index_name: index_name,
      max_results: max_results
    ).vectors
  end

  # Bucket情報を表示する
  # @param bucket [Object] Vector bucket情報
  def print_bucket_info(bucket)
    puts "S3 Vector buckets #{bucket.vector_bucket_name}"
  end

  # Index情報とそれに含まれるVector情報を表示する
  # @param index [Object] Index情報
  # @param bucket_name [String] Vector bucket名
  # @param max_results [Integer] 取得する最大結果数
  def print_index_info(index, bucket_name, max_results)
    puts "  Index: #{index.index_name}"
    list_vectors(bucket_name, index.index_name, max_results).each do |vector|
      puts "    Vector: #{vector.vector_name}"
    end
  end
end

# ブラウザーのインスタンスを作成し、リソース一覧を表示
browser = S3VectorsBrowser.new
browser.list_all_resources
